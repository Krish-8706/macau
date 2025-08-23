package com.example.macau

import android.content.Context
import android.app.NotificationManager
import android.media.AudioManager
import android.os.Build
import android.provider.Settings
import android.content.Intent

class RingerModeHelper(private val context: Context) {

    fun setRingerMode(mode: Int) {
        val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
            !notificationManager.isNotificationPolicyAccessGranted) {
            val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            return
        }

        when (mode) {
            0 -> audioManager.ringerMode = AudioManager.RINGER_MODE_SILENT
            1 -> audioManager.ringerMode = AudioManager.RINGER_MODE_VIBRATE
            2 -> audioManager.ringerMode = AudioManager.RINGER_MODE_NORMAL
        }
    }

    fun getCurrentRingerMode(): Int {
        val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        return audioManager.ringerMode // 0 = silent, 1 = vibrate, 2 = normal
    }
}
