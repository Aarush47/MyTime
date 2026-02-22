package com.example.myclock

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import java.util.*

class AlarmScheduler(private val context: Context) {
    
    private val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
    
    fun scheduleAlarm(alarm: AlarmData) {
        val intent = Intent(context, AlarmReceiver::class.java).apply {
            putExtra("ALARM_ID", alarm.id.hashCode())
            putExtra("ALARM_LABEL", alarm.label)
            putExtra("ALARM_TIME", alarm.getFormattedTime())
        }
        
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            alarm.id.hashCode(),
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
        
        val calendar = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, alarm.hour)
            set(Calendar.MINUTE, alarm.minute)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
            
            // If the time has already passed today, schedule for tomorrow
            if (timeInMillis <= System.currentTimeMillis()) {
                add(Calendar.DAY_OF_MONTH, 1)
            }
        }
        
        // Schedule the alarm
        alarmManager.setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            calendar.timeInMillis,
            pendingIntent
        )
        
        // If repeat is enabled, reschedule after trigger
        if (alarm.repeatDays.isNotEmpty()) {
            scheduleRepeatingAlarm(alarm)
        }
    }
    
    private fun scheduleRepeatingAlarm(alarm: AlarmData) {
        val calendar = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, alarm.hour)
            set(Calendar.MINUTE, alarm.minute)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }
        
        // Find the next day when alarm should trigger
        var daysToAdd = 0
        val currentDay = calendar.get(Calendar.DAY_OF_WEEK)
        
        for (i in 0..7) {
            val checkDay = (currentDay + i - 1) % 7 + 1
            if (alarm.repeatDays.contains(checkDay) && 
                (i > 0 || calendar.timeInMillis > System.currentTimeMillis())) {
                daysToAdd = i
                break
            }
        }
        
        calendar.add(Calendar.DAY_OF_MONTH, daysToAdd)
        
        val intent = Intent(context, AlarmReceiver::class.java).apply {
            putExtra("ALARM_ID", alarm.id.hashCode())
            putExtra("ALARM_LABEL", alarm.label)
            putExtra("ALARM_TIME", alarm.getFormattedTime())
        }
        
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            alarm.id.hashCode(),
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
        
        alarmManager.setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            calendar.timeInMillis,
            pendingIntent
        )
    }
    
    fun cancelAlarm(alarmId: String) {
        val intent = Intent(context, AlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            alarmId.hashCode(),
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_NO_CREATE
        )
        
        pendingIntent?.let {
            alarmManager.cancel(it)
            it.cancel()
        }
    }
}
