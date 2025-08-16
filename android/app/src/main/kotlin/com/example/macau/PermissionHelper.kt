package com.example.macau

import android.content.Context
import android.content.Intent
import android.provider.Settings

class PermissionHelper(private val context: Context) {

    fun openNotificationListenerSettings() {
        val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }
}
