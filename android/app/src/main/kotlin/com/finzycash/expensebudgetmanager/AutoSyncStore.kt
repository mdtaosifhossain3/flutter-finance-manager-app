package com.finzycash.expensebudgetmanager

import android.content.Context
import android.content.SharedPreferences
import org.json.JSONArray
import org.json.JSONObject

/**
 * Auto Sync state, kept on the phone only: the on/off switch, the app
 * language for pop-up text, detected transactions waiting for the user, and
 * keys of messages already seen (notifications are often re-posted).
 */
object AutoSyncStore {
    private const val PREFS = "auto_sync"
    private const val KEY_ENABLED = "enabled"
    private const val KEY_LANG = "lang"
    private const val KEY_PENDING = "pending"
    private const val KEY_SEEN = "seen"
    private const val KEY_LAST_ID = "last_id"

    private const val MAX_PENDING = 50
    private const val MAX_SEEN = 300

    /** Same transaction from the SMS and the wallet app's own push. */
    private const val CROSS_SOURCE_WINDOW_MS = 3 * 60 * 1000L

    private fun prefs(context: Context): SharedPreferences =
        context.applicationContext.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    fun isEnabled(context: Context) = prefs(context).getBoolean(KEY_ENABLED, false)

    fun setEnabled(context: Context, enabled: Boolean) {
        prefs(context).edit().putBoolean(KEY_ENABLED, enabled).apply()
    }

    fun language(context: Context): String = prefs(context).getString(KEY_LANG, "bn") ?: "bn"

    fun setLanguage(context: Context, lang: String) {
        prefs(context).edit().putString(KEY_LANG, lang).apply()
    }

    @Synchronized
    fun pending(context: Context): JSONArray =
        try {
            JSONArray(prefs(context).getString(KEY_PENDING, "[]"))
        } catch (_: Exception) {
            JSONArray()
        }

    @Synchronized
    fun find(context: Context, id: Long): JSONObject? {
        val list = pending(context)
        for (i in 0 until list.length()) {
            val item = list.getJSONObject(i)
            if (item.getLong("id") == id) return item
        }
        return null
    }

    /**
     * Queues a detected transaction. Returns null when it was already seen
     * (same TrxID or same text), so the user is never asked twice.
     */
    @Synchronized
    fun add(
        context: Context,
        text: String,
        source: String,
        sender: String,
        d: AutoSyncDetector.Detected,
    ): JSONObject? {
        val p = prefs(context)
        val normalized = text.replace(Regex("""\s+"""), " ").trim()
        val key = d.trxId?.let { "trx:$it" } ?: "txt:${normalized.lowercase().hashCode()}"

        val seen = try {
            JSONArray(p.getString(KEY_SEEN, "[]"))
        } catch (_: Exception) {
            JSONArray()
        }
        for (i in 0 until seen.length()) {
            if (seen.getString(i) == key) return null
        }

        val now = System.currentTimeMillis()
        val list = pending(context)
        for (i in 0 until list.length()) {
            val other = list.getJSONObject(i)
            if (other.optString("source") != source &&
                other.optString("amount") == d.amount &&
                other.optString("kind") == d.kind &&
                now - other.optLong("postedAt") < CROSS_SOURCE_WINDOW_MS
            ) {
                return null
            }
        }

        val id = maxOf(now, p.getLong(KEY_LAST_ID, 0) + 1)
        val item = JSONObject()
            .put("id", id)
            .put("text", normalized)
            .put("source", source)
            .put("sender", sender)
            .put("amount", d.amount)
            .put("kind", d.kind)
            .put("party", d.party ?: JSONObject.NULL)
            .put("trxId", d.trxId ?: JSONObject.NULL)
            .put("postedAt", now)

        list.put(item)
        val trimmed = JSONArray()
        val start = maxOf(0, list.length() - MAX_PENDING)
        for (i in start until list.length()) trimmed.put(list.get(i))

        seen.put(key)
        val seenTrimmed = JSONArray()
        val seenStart = maxOf(0, seen.length() - MAX_SEEN)
        for (i in seenStart until seen.length()) seenTrimmed.put(seen.get(i))

        p.edit()
            .putString(KEY_PENDING, trimmed.toString())
            .putString(KEY_SEEN, seenTrimmed.toString())
            .putLong(KEY_LAST_ID, id)
            .apply()
        return item
    }

    @Synchronized
    fun remove(context: Context, ids: Collection<Long>) {
        val list = pending(context)
        val kept = JSONArray()
        for (i in 0 until list.length()) {
            val item = list.getJSONObject(i)
            if (item.getLong("id") !in ids) kept.put(item)
        }
        prefs(context).edit().putString(KEY_PENDING, kept.toString()).apply()
    }

    @Synchronized
    fun clear(context: Context) {
        prefs(context).edit().putString(KEY_PENDING, "[]").apply()
    }

    /** Stable notification id for a queued item. */
    fun notificationId(id: Long): Int = 5_000_000 + (id % 1_000_000).toInt()
}
