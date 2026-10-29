package com.finzycash.expensebudgetmanager

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

/**
 * Link to the Flutter side while the app is on screen, so a detected
 * transaction shows as an in-app pop-up instead of a notification.
 */
object AutoSyncBridge {
    private val main = Handler(Looper.getMainLooper())

    /** Set by MainActivity between onResume and onPause. */
    @Volatile
    var channel: MethodChannel? = null

    /** Set by Flutter while the main screen can show a pop-up. */
    @Volatile
    var uiReady = false

    /** True when the app is on screen and took the item. */
    fun deliver(item: JSONObject): Boolean {
        val ch = channel ?: return false
        if (!uiReady) return false
        main.post { ch.invokeMethod("onDetected", toMap(item)) }
        return true
    }

    fun notifyChanged() {
        val ch = channel ?: return
        main.post { ch.invokeMethod("onPendingChanged", null) }
    }

    fun toMap(item: JSONObject): Map<String, Any?> = mapOf(
        "id" to item.getLong("id"),
        "text" to item.optString("text"),
        "source" to item.optString("source"),
        "sender" to item.optString("sender"),
        "amount" to item.optString("amount"),
        "kind" to item.optString("kind"),
        "party" to item.opt("party").takeIf { it != JSONObject.NULL },
        "trxId" to item.opt("trxId").takeIf { it != JSONObject.NULL },
        "postedAt" to item.optLong("postedAt"),
    )
}
