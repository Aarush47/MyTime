package com.example.myclock

import java.util.*

data class AlarmData(
    val id: String = UUID.randomUUID().toString(),
    val hour: Int,
    val minute: Int,
    var isEnabled: Boolean = true,
    var label: String = "",
    var repeatDays: List<Int> = emptyList() // 1=Monday, 7=Sunday, 0=No repeat
) {
    fun getFormattedTime(): String {
        val h = if (hour == 0) 12 else if (hour > 12) hour - 12 else hour
        val period = if (hour >= 12) "PM" else "AM"
        return String.format("%02d:%02d %s", h, minute, period)
    }
    
    fun getRepeatText(): String {
        if (repeatDays.isEmpty()) return "Once"
        if (repeatDays.size == 7) return "Every day"
        if (repeatDays.containsAll(listOf(1, 2, 3, 4, 5))) return "Weekdays"
        if (repeatDays.containsAll(listOf(6, 7))) return "Weekends"
        
        val dayNames = listOf("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
        return repeatDays.sorted().joinToString(", ") { dayNames[it - 1] }
    }
}