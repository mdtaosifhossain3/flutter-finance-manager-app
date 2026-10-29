package com.finzycash.expensebudgetmanager

import android.app.Notification
import android.content.ComponentName
import android.content.Context
import android.os.Build
import android.os.Bundle
import android.os.Parcelable
import android.provider.Settings
import android.provider.Telephony
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log

/**
 * Reads the notification an SMS app shows for a bKash / Nagad / Rocket / bank
 * SMS (works with mobile data off), and the wallet apps' own pushes. Every
 * other notification is ignored and nothing leaves the phone.
 */
class TransactionNotificationListener : NotificationListenerService() {

    companion object {
        private const val TAG = "AutoSync"

        private val SMS_APPS = setOf(
            "com.google.android.apps.messaging",
            "com.samsung.android.messaging",
            "com.android.mms",
            "com.android.messaging",
            "com.oneplus.mms",
            "com.coloros.mms",
            "com.transsion.message",
            "com.truecaller",
        )

        private val WALLET_APPS = setOf(
            "com.bKash.customerapp",
            "com.konasl.nagad",
            "com.dbbl.mbs.apps.main",
        )

        fun component(context: Context) =
            ComponentName(context, TransactionNotificationListener::class.java)

        /** Whether the user has granted Notification access to the app. */
        fun hasAccess(context: Context): Boolean {
            val enabled = Settings.Secure.getString(
                context.contentResolver,
                "enabled_notification_listeners",
            ) ?: return false
            val me = component(context)
            return enabled.split(":").any {
                ComponentName.unflattenFromString(it) == me
            }
        }

        /** Reconnects the listener if the system or a battery saver dropped it. */
        fun rebind(context: Context) {
            if (!hasAccess(context)) return
            try {
                requestRebind(component(context))
            } catch (e: Exception) {
                Log.w(TAG, "rebind failed", e)
            }
        }
    }

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        sbn ?: return
        try {
            handle(sbn)
        } catch (e: Exception) {
            // Never crash the listener: Android would unbind it.
            Log.w(TAG, "could not read notification", e)
        }
    }

    private fun handle(sbn: StatusBarNotification) {
        if (!AutoSyncStore.isEnabled(this)) return
        val pkg = sbn.packageName ?: return
        if (pkg == packageName) return

        val isSmsApp = pkg in SMS_APPS || pkg == Telephony.Sms.getDefaultSmsPackage(this)
        val isWalletApp = pkg in WALLET_APPS
        if (!isSmsApp && !isWalletApp) return

        val notification = sbn.notification ?: return
        if (notification.flags and Notification.FLAG_GROUP_SUMMARY != 0) return

        val extras = notification.extras ?: return
        val title = extras.getCharSequence(Notification.EXTRA_TITLE)?.toString().orEmpty()
        val text = latestText(extras)?.trim().orEmpty()
        if (text.isEmpty()) return

        // Messages from people can mention "Tk" too; only trust bank/wallet
        // senders, or text that clearly is a bank message.
        if (isSmsApp &&
            !AutoSyncDetector.isFinancialSender(title) &&
            !AutoSyncDetector.looksTransactional(text)
        ) {
            return
        }

        val detected = AutoSyncDetector.detect(text) ?: return
        val item = AutoSyncStore.add(this, text, pkg, title, detected) ?: return

        if (!AutoSyncBridge.deliver(item)) {
            AutoSyncNotifier.show(this, item)
        }
    }

    /**
     * Only the newest message: SMS apps re-post one notification per
     * conversation that carries the earlier messages too.
     */
    private fun latestText(extras: Bundle): String? {
        val messages = messagesOf(extras)
        if (!messages.isNullOrEmpty()) {
            val last = messages.last() as? Bundle
            last?.getCharSequence("text")?.toString()?.let { return it }
        }
        extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString()?.let {
            if (it.isNotBlank()) return it
        }
        return extras.getCharSequence(Notification.EXTRA_TEXT)?.toString()
    }

    @Suppress("DEPRECATION")
    private fun messagesOf(extras: Bundle): Array<Parcelable>? =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            extras.getParcelableArray(Notification.EXTRA_MESSAGES, Parcelable::class.java)
        } else {
            extras.getParcelableArray(Notification.EXTRA_MESSAGES)
        }
}
