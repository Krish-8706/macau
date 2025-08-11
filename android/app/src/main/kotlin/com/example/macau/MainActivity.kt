package com.example.macau

import android.media.AudioManager
import android.content.Context
import android.app.NotificationManager
import android.os.Build
import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import android.util.Log

class MainActivity : FlutterActivity() {
    private val CHANNEL = "ringer_mode_channel"
    private val NOTIF_CHANNEL = "missed_call_notifications"
    private val TAG = "MainActivity"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setRingerMode" -> {
                        val mode = call.argument<Int>("mode")
                        if (mode != null && mode in 0..2) {
                            setRingerMode(mode)
                            result.success(null)
                        } else {
                            result.error("INVALID_ARGUMENT", "Mode must be 0, 1, or 2", null)
                        }
                    }
                    "checkNotificationListenerPermission" -> {
                        checkNotificationListenerPermission()
                        result.success(null)
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

    private fun setRingerMode(mode: Int) {
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Check Do Not Disturb access permission for changing ringer mode
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
            !notificationManager.isNotificationPolicyAccessGranted) {
            val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
            startActivity(intent)
            return
        }

        when (mode) {
            0 -> audioManager.ringerMode = AudioManager.RINGER_MODE_SILENT
            1 -> audioManager.ringerMode = AudioManager.RINGER_MODE_VIBRATE
            2 -> audioManager.ringerMode = AudioManager.RINGER_MODE_NORMAL
        }
    }

    private fun checkNotificationListenerPermission() {
        val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
        startActivity(intent)
    }
}
