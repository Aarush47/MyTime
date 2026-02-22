package com.example.myclock

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import java.text.SimpleDateFormat
import java.util.*

class CalendarFragment : Fragment() {
    
    private lateinit var calendarGrid: RecyclerView
    private val calendar = Calendar.getInstance()
    
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_calendar, container, false)
    }
    
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        
        val dayText = view.findViewById<TextView>(R.id.calendarDay)
        val monthText = view.findViewById<TextView>(R.id.calendarMonth)
        val dayNameText = view.findViewById<TextView>(R.id.calendarDayName)
        val monthYearText = view.findViewById<TextView>(R.id.calendarMonthYear)
        calendarGrid = view.findViewById(R.id.calendarGrid)
        
        // Set current date info
        dayText.text = calendar.get(Calendar.DAY_OF_MONTH).toString()
        monthText.text = SimpleDateFormat("MMMM", Locale.getDefault()).format(calendar.time)
        dayNameText.text = SimpleDateFormat("EEEE", Locale.getDefault()).format(calendar.time)
        monthYearText.text = SimpleDateFormat("MMMM yyyy", Locale.getDefault()).format(calendar.time)
        
        // Setup calendar grid
        calendarGrid.layoutManager = GridLayoutManager(context, 7)
        calendarGrid.adapter = CalendarAdapter(getDaysInMonth())
    }
    
    private fun getDaysInMonth(): List<CalendarDay> {
        val days = mutableListOf<CalendarDay>()
        val tempCal = calendar.clone() as Calendar
        
        tempCal.set(Calendar.DAY_OF_MONTH, 1)
        val firstDayOfWeek = tempCal.get(Calendar.DAY_OF_WEEK) - 1
        val daysInMonth = tempCal.getActualMaximum(Calendar.DAY_OF_MONTH)
        val today = calendar.get(Calendar.DAY_OF_MONTH)
        
        // Add empty days for offset
        repeat(firstDayOfWeek) {
            days.add(CalendarDay("", false))
        }
        
        // Add actual days
        for (day in 1..daysInMonth) {
            days.add(CalendarDay(day.toString(), day == today))
        }
        
        return days
    }
}

data class CalendarDay(val day: String, val isToday: Boolean)

class CalendarAdapter(private val days: List<CalendarDay>) : 
    RecyclerView.Adapter<CalendarAdapter.ViewHolder>() {
    
    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val dayText: TextView = view.findViewById(R.id.dayText)
    }
    
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.calendar_day_item, parent, false)
        return ViewHolder(view)
    }
    
    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val day = days[position]
        holder.dayText.text = day.day
        holder.dayText.alpha = if (day.day.isEmpty()) 0f else 1f
        
        if (day.isToday && day.day.isNotEmpty()) {
            holder.dayText.setBackgroundResource(R.drawable.calendar_today_bg)
            holder.dayText.setTextColor(0xFF000000.toInt())
        } else {
            holder.dayText.background = null
            holder.dayText.setTextColor(0xFFFFFFFF.toInt())
        }
    }
    
    override fun getItemCount() = days.size
}