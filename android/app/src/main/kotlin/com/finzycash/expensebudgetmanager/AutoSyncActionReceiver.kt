package com.finzycash.expensebudgetmanager

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/** "Ignore" on the Auto Sync notification: drop it without opening the app. */
class AutoSyncActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != AutoSyncNotifier.ACTION_IGNORE) return
        val id = intent.getLongExtra(AutoSyncNotifier.EXTRA_ID, -1)
        if (id < 0) return
        AutoSyncStore.remove(context, listOf(id))
        AutoSyncNotifier.cancel(context, id)
        AutoSyncBridge.notifyChanged()
    }
}
