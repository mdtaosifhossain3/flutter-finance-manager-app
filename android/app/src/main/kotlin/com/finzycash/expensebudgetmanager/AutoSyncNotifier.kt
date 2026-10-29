package com.finzycash.expensebudgetmanager

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import org.json.JSONObject

/** Heads-up "৳500 sent to … Add to expense?" notification with Add / Ignore. */
object AutoSyncNotifier {
    const val CHANNEL_ID = "auto_sync_transactions"
    const val ACTION_OPEN = "com.finzycash.expensebudgetmanager.AUTO_SYNC_OPEN"
    const val ACTION_IGNORE = "com.finzycash.expensebudgetmanager.AUTO_SYNC_IGNORE"
    const val EXTRA_ID = "auto_sync_id"

    private fun bn(context: Context) = AutoSyncStore.language(context) == "bn"

    private fun createChannel(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = context.getSystemService(NotificationManager::class.java)
        if (manager.getNotificationChannel(CHANNEL_ID) != null) return
        val channel = NotificationChannel(
            CHANNEL_ID,
            if (bn(context)) "অটো-ট্র্যাকিং লেনদেন" else "Auto-detected transactions",
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description = if (bn(context)) {
                "বিকাশ, নগদ, রকেট ও ব্যাংকের লেনদেন খরচে যোগ করার জন্য"
            } else {
                "bKash, Nagad, Rocket and bank transactions to add as expenses"
            }
        }
        manager.createNotificationChannel(channel)
    }

    fun canPost(context: Context): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
            context.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) !=
            PackageManager.PERMISSION_GRANTED
        ) {
            return false
        }
        return context.getSystemService(NotificationManager::class.java).areNotificationsEnabled()
    }

    /** Pop-up wording, also used by the in-app dialog. */
    fun texts(context: Context, item: JSONObject): Pair<String, String> {
        val bn = bn(context)
        val amount = "৳" + if (bn) toBanglaDigits(item.optString("amount")) else item.optString("amount")
        val party = item.optString("party").takeIf { it.isNotEmpty() && it != "null" }
        val wallet = walletName(item, bn)
        val kind = item.optString("kind")
        val income = kind == "received"
        val transfer = kind in setOf("cash_out", "cash_in", "atm", "add_money")

        val action = if (bn) {
            when (kind) {
                "cash_out" -> "ক্যাশ আউট"
                "cash_in" -> "ক্যাশ ইন"
                "atm" -> "এটিএম থেকে উত্তোলন"
                "add_money" -> "অ্যাড মানি"
                "recharge" -> "মোবাইল রিচার্জ"
                "bill" -> "বিল পরিশোধ"
                "received" -> "পেয়েছেন"
                "sent" -> "পাঠিয়েছেন"
                "payment" -> "পেমেন্ট"
                else -> "খরচ"
            }
        } else {
            when (kind) {
                "cash_out" -> "Cash out"
                "cash_in" -> "Cash in"
                "atm" -> "ATM withdrawal"
                "add_money" -> "Add money"
                "recharge" -> "Mobile recharge"
                "bill" -> "Bill payment"
                "received" -> "Received from"
                "sent" -> "Sent to"
                "payment" -> "Payment to"
                else -> "Debit"
            }
        }

        val title = if (bn) "$wallet লেনদেন পাওয়া গেছে" else "$wallet transaction detected"
        val line = if (bn) {
            val who = party?.let { " ($it)" } ?: ""
            "$amount $action$who"
        } else {
            val who = party?.let { " $it" } ?: ""
            "$amount $action$who"
        }
        val ask = when {
            transfer -> if (bn) "ওয়ালেটে যোগ করবেন?" else "Add to wallets?"
            income -> if (bn) "আয়ে যোগ করবেন?" else "Add to income?"
            else -> if (bn) "খরচে যোগ করবেন?" else "Add to expense?"
        }
        return title to "$line • $ask"
    }

    private fun walletName(item: JSONObject, bn: Boolean): String {
        val all = (item.optString("sender") + " " + item.optString("source") + " " +
            item.optString("text")).lowercase()
        return when {
            all.contains("nagad") -> if (bn) "নগদ" else "Nagad"
            all.contains("rocket") || all.contains("dbbl.mbs") || all.contains("16216") ->
                if (bn) "রকেট" else "Rocket"
            all.contains("upay") -> if (bn) "উপায়" else "Upay"
            all.contains("bkash") || all.contains("trxid") -> if (bn) "বিকাশ" else "bKash"
            else -> if (bn) "ব্যাংক" else "Bank"
        }
    }

    private fun toBanglaDigits(s: String) =
        s.map { if (it in '0'..'9') '০' + (it - '0') else it }.joinToString("")

    fun show(context: Context, item: JSONObject) {
        if (!canPost(context)) return
        createChannel(context)
        val id = item.getLong("id")
        val notifId = AutoSyncStore.notificationId(id)
        val (title, body) = texts(context, item)
        val bn = bn(context)

        val immutable = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        val openIntent = Intent(context, MainActivity::class.java).apply {
            action = ACTION_OPEN
            putExtra(EXTRA_ID, id)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
        }
        val open = PendingIntent.getActivity(context, notifId, openIntent, immutable)
        val ignoreIntent = Intent(context, AutoSyncActionReceiver::class.java).apply {
            action = ACTION_IGNORE
            putExtra(EXTRA_ID, id)
        }
        val ignore = PendingIntent.getBroadcast(context, notifId, ignoreIntent, immutable)

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(context, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(context).setPriority(Notification.PRIORITY_HIGH)
                .setDefaults(Notification.DEFAULT_ALL)
        }
        val notification = builder
            .setSmallIcon(R.drawable.notification_icon)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(Notification.BigTextStyle().bigText(body))
            .setContentIntent(open)
            .setAutoCancel(true)
            .setCategory(Notification.CATEGORY_RECOMMENDATION)
            .addAction(
                Notification.Action.Builder(null, if (bn) "যোগ করুন" else "Add", open).build(),
            )
            .addAction(
                Notification.Action.Builder(null, if (bn) "বাদ দিন" else "Ignore", ignore).build(),
            )
            .build()

        try {
            context.getSystemService(NotificationManager::class.java).notify(notifId, notification)
        } catch (_: SecurityException) {
            // Permission revoked between the check and the call.
        }
    }

    fun cancel(context: Context, id: Long) {
        context.getSystemService(NotificationManager::class.java)
            .cancel(AutoSyncStore.notificationId(id))
    }
}
