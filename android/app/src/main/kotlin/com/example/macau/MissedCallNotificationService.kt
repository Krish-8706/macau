package com.example.macau

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import io.flutter.plugin.common.EventChannel

class MissedCallNotificationService : NotificationListenerService() {

    companion object {
        var eventSink: EventChannel.EventSink? = null
        private const val TAG = "MissedCallService"
    }

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val packageName = sbn.packageName
        val extras = sbn.notification.extras
        val title = extras.getString("android.title") ?: ""
        val text = extras.getCharSequence("android.text")?.toString() ?: ""

        Log.d(TAG, "Notification posted from $packageName: $title - $text")

        // Filter missed call notifications
        if ((packageName.contains("dialer") || packageName.contains("phone") || packageName.contains("com.android.phone"))
            && title.contains("Missed call", ignoreCase = true)) {
            Log.d(TAG, "Missed call notification detected: $title - $text")
            eventSink?.success("$title: $text")
        }
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification) {
        Log.d(TAG, "Notification removed: ${sbn.packageName} - ${sbn.notification.extras.getString("android.title")}")
    }
}
