package com.example.myclock

import android.content.Context
import android.content.SharedPreferences
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

class AlarmManager(context: Context) {
    private val prefs: SharedPreferences = context.getSharedPreferences("alarms", Context.MODE_PRIVATE)
    private val gson = Gson()
    
    fun saveAlarms(alarms: List<AlarmData>) {
        val json = gson.toJson(alarms)
        prefs.edit().putString("alarm_list", json).apply()
    }
    
    fun loadAlarms(): MutableList<AlarmData> {
        val json = prefs.getString("alarm_list", null) ?: return mutableListOf()
        val type = object : TypeToken<List<AlarmData>>() {}.type
        return gson.fromJson(json, type) ?: mutableListOf()
    }
    
    fun addAlarm(alarm: AlarmData) {
        val alarms = loadAlarms()
        alarms.add(alarm)
        saveAlarms(alarms)
    }
    
    fun updateAlarm(alarm: AlarmData) {
        val alarms = loadAlarms()
        val index = alarms.indexOfFirst { it.id == alarm.id }
        if (index != -1) {
            alarms[index] = alarm
            saveAlarms(alarms)
        }
    }
    
    fun deleteAlarm(id: String) {
        val alarms = loadAlarms()
        alarms.removeAll { it.id == id }
        saveAlarms(alarms)
    }
    
    fun toggleAlarm(id: String) {
        val alarms = loadAlarms()
        val alarm = alarms.find { it.id == id }
        alarm?.let {
            it.isEnabled = !it.isEnabled
            saveAlarms(alarms)
        }
    }
}