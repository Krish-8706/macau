package com.example.macau

import android.content.Context
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "ringer_mode_channel"
    private val NOTIF_CHANNEL = "missed_call_notifications"
    private val TAG = "MainActivity"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val ringerModeHelper = RingerModeHelper(this)
        val permissionHelper = PermissionHelper(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setRingerMode" -> {
                        val mode = call.argument<Int>("mode")
                        if (mode != null && mode in 0..2) {
                            ringerModeHelper.setRingerMode(mode)
                            result.success(null)
                        } else {
                            result.error("INVALID_ARGUMENT", "Mode must be 0, 1, or 2", null)
                        }
                    }

                    "checkNotificationListenerPermission" -> {
                        if (permissionHelper.hasNotificationListenerPermission()) {
                            // Permission already granted
                            result.success(true)
                        } else {
                            // Not granted → open settings
                            permissionHelper.openNotificationListenerSettings()
                            result.success(false)
                        }
                    }

                    "getMissedCallLogs" -> {
                        val prefs = getSharedPreferences("missed_call_prefs", Context.MODE_PRIVATE)
                        val logsJson = prefs.getString("call_logs", "[]")

                        // Clear logs once fetched, so they don't duplicate forever
                        prefs.edit().putString("call_logs", "[]").apply()

                        result.success(logsJson)
                    }

                    else -> result.notImplemented()
                }
            }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, NOTIF_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    Log.d(TAG, "EventChannel onListen called")
                    MissedCallNotificationService.eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    Log.d(TAG, "EventChannel onCancel called")
                    MissedCallNotificationService.eventSink = null
                }
            })
    }
}
