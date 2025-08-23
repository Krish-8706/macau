package com.example.macau

import android.content.Context
import android.content.Intent
import android.provider.Settings
import android.text.TextUtils
import android.service.notification.NotificationListenerService
import android.app.AppOpsManager
import android.content.ComponentName

class PermissionHelper(private val context: Context) {

    fun hasNotificationListenerPermission(): Boolean {
        val flat = Settings.Secure.getString(context.contentResolver, "enabled_notification_listeners")
        if (!flat.isNullOrEmpty()) {
            val names = flat.split(":")
            for (name in names) {
                val cn = ComponentName.unflattenFromString(name)
                if (cn != null && TextUtils.equals(context.packageName, cn.packageName)) {
                    return true
                }
            }
        }
        return false
    }

    fun openNotificationListenerSettings() {
        val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }
}
