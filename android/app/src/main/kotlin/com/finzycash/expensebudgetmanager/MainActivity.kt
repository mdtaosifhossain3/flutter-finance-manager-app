package com.finzycash.expensebudgetmanager

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val TAG = "MainActivity"

    // Text shared into the app (e.g. a bKash SMS), until Flutter takes it.
    private var sharedText: String? = null

    // Auto Sync item the user tapped in a notification, until Flutter takes it.
    private var autoSyncOpenId: Long? = null
    private var autoSyncChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // App signature helper for SMS verification
        val appSignatureHelper = AppSignatureHelper(this)
        for (signature in appSignatureHelper.appSignatures) {
            Log.d("AppSignatureHelper", "Hash: $signature")
        }
        handleShareIntent(intent)
        handleAutoSyncIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleShareIntent(intent)
        handleAutoSyncIntent(intent)
        if (autoSyncOpenId != null) autoSyncChannel?.invokeMethod("onOpenRequested", null)
    }

    override fun onResume() {
        super.onResume()
        AutoSyncBridge.channel = autoSyncChannel
        if (AutoSyncStore.isEnabled(this)) TransactionNotificationListener.rebind(this)
    }

    override fun onPause() {
        AutoSyncBridge.channel = null
        super.onPause()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "hishab_rakhi/share")
            .setMethodCallHandler { call, result ->
                if (call.method == "takeSharedText") {
                    result.success(sharedText)
                    sharedText = null
                } else {
                    result.notImplemented()
                }
            }

        val autoSync = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "hishab_rakhi/auto_sync")
        autoSyncChannel = autoSync
        autoSync.setMethodCallHandler { call, result ->
            try {
                handleAutoSyncCall(call.method, call.arguments, result)
            } catch (e: Exception) {
                Log.w(TAG, "auto_sync ${call.method} failed", e)
                result.error("auto_sync", e.message, null)
            }
        }
    }

    private fun handleAutoSyncCall(method: String, args: Any?, result: MethodChannel.Result) {
        when (method) {
            "status" -> result.success(
                mapOf(
                    "enabled" to AutoSyncStore.isEnabled(this),
                    "access" to TransactionNotificationListener.hasAccess(this),
                    "notifications" to AutoSyncNotifier.canPost(this),
                ),
            )
            "setEnabled" -> {
                val on = args as? Boolean ?: false
                AutoSyncStore.setEnabled(this, on)
                if (on) TransactionNotificationListener.rebind(this)
                result.success(null)
            }
            "setUiReady" -> {
                AutoSyncBridge.uiReady = args as? Boolean ?: false
                result.success(null)
            }
            "setLanguage" -> {
                (args as? String)?.let { AutoSyncStore.setLanguage(this, it) }
                result.success(null)
            }
            "openAccessSettings" -> {
                result.success(openNotificationAccessSettings())
            }
            "openAppSettings" -> {
                startActivity(
                    Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                        .setData(Uri.fromParts("package", packageName, null)),
                )
                result.success(null)
            }
            "pending" -> {
                val list = AutoSyncStore.pending(this)
                result.success((0 until list.length()).map { AutoSyncBridge.toMap(list.getJSONObject(it)) })
            }
            "remove" -> {
                val ids = (args as? List<*>)?.mapNotNull { (it as? Number)?.toLong() } ?: emptyList()
                AutoSyncStore.remove(this, ids)
                ids.forEach { AutoSyncNotifier.cancel(this, it) }
                result.success(null)
            }
            "takeOpenRequest" -> {
                result.success(autoSyncOpenId)
                autoSyncOpenId = null
            }
            else -> result.notImplemented()
        }
    }

    /** Opens the system screen where the user allows Notification access. */
    private fun openNotificationAccessSettings(): Boolean {
        val component = TransactionNotificationListener.component(this)
        val intents = mutableListOf<Intent>()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            intents += Intent(Settings.ACTION_NOTIFICATION_LISTENER_DETAIL_SETTINGS)
                .putExtra(
                    Settings.EXTRA_NOTIFICATION_LISTENER_COMPONENT_NAME,
                    component.flattenToString(),
                )
        }
        intents += Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
        for (intent in intents) {
            try {
                startActivity(intent)
                return true
            } catch (_: Exception) {
                // Some phones lack the detail screen; try the list.
            }
        }
        return false
    }

    private fun handleAutoSyncIntent(intent: Intent?) {
        if (intent?.action != AutoSyncNotifier.ACTION_OPEN) return
        val id = intent.getLongExtra(AutoSyncNotifier.EXTRA_ID, -1)
        if (id >= 0) {
            autoSyncOpenId = id
            AutoSyncNotifier.cancel(this, id)
        }
        // Don't handle the same tap again after rotation or recreation.
        intent.action = null
    }

    private fun handleShareIntent(intent: Intent?) {
        if (intent?.action == Intent.ACTION_SEND && intent.type == "text/plain") {
            sharedText = intent.getStringExtra(Intent.EXTRA_TEXT)
        }
    }
}
