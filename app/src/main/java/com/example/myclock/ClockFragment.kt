package com.example.myclock

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageButton
import android.widget.LinearLayout
import android.widget.ProgressBar
import android.widget.TextView
import androidx.fragment.app.Fragment
import java.text.SimpleDateFormat
import java.util.*

class ClockFragment : Fragment() {
    
    private lateinit var timeMainText: TextView
    private lateinit var amPmText: TextView
    private lateinit var dateText: TextView
    private lateinit var dayText: TextView
    private lateinit var secondsText: TextView
    private lateinit var secondsProgress: ProgressBar
    private lateinit var formatBtn: Button
    private lateinit var ambientName: TextView
    private lateinit var ambientStatus: TextView
    private lateinit var ambientPlayBtn: ImageButton
    private lateinit var eventsContainer: LinearLayout
    
    private var use24HourFormat = false
    private var isPlaying = false
    
    private val handler = Handler(Looper.getMainLooper())
    private val updateRunnable = object : Runnable {
        override fun run() {
            updateClock()
            handler.postDelayed(this, 500) // Update twice per second for smooth progress
        }
    }
    
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_clock, container, false)
    }
    
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        
        timeMainText = view.findViewById(R.id.timeMainText)
        amPmText = view.findViewById(R.id.amPmText)
        dateText = view.findViewById(R.id.dateText)
        dayText = view.findViewById(R.id.dayText)
        secondsText = view.findViewById(R.id.secondsText)
        secondsProgress = view.findViewById(R.id.secondsProgress)
        formatBtn = view.findViewById(R.id.formatBtn)
        ambientName = view.findViewById(R.id.ambientName)
        ambientStatus = view.findViewById(R.id.ambientStatus)
        ambientPlayBtn = view.findViewById(R.id.ambientPlayBtn)
        eventsContainer = view.findViewById(R.id.eventsContainer)
        
        // Apply Coolvetica font to time display
        timeMainText.typeface = FontUtils.getCoolveticaFont(requireContext())
        
        // Format toggle button
        formatBtn.setOnClickListener {
            use24HourFormat = !use24HourFormat
            formatBtn.text = if (use24HourFormat) "24H" else "12H"
            updateClock()
        }
        
        // Ambient play button
        ambientPlayBtn.setOnClickListener {
            isPlaying = !isPlaying
            ambientStatus.text = if (isPlaying) "Now playing" else "Tap to play"
            ambientPlayBtn.setImageResource(if (isPlaying) android.R.drawable.ic_media_pause else android.R.drawable.ic_media_play)
        }
        
        // Add demo events
        addDemoEvents()
        
        // Start the clock immediately
        updateClock()
        handler.post(updateRunnable)
    }
    
    private fun addDemoEvents() {
        val events = listOf(
            Triple("Morning Meeting", "9:00 AM", "#5DCAA5"),
            Triple("Lunch Break", "1:00 PM", "#EF9F27"),
            Triple("Project Review", "4:30 PM", "#7F77DD")
        )
        
        for ((title, time, color) in events) {
            val eventView = LayoutInflater.from(context).inflate(R.layout.event_item, eventsContainer, false)
            val dotView = eventView.findViewById<View>(R.id.eventDot)
            val titleView = eventView.findViewById<TextView>(R.id.eventTitle)
            val timeView = eventView.findViewById<TextView>(R.id.eventTime)
            
            dotView.setBackgroundColor(android.graphics.Color.parseColor(color))
            titleView.text = title
            timeView.text = time
            
            eventsContainer.addView(eventView)
        }
    }
    
    override fun onResume() {
        super.onResume()
        handler.removeCallbacks(updateRunnable)
        handler.post(updateRunnable)
    }
    
    override fun onPause() {
        super.onPause()
        handler.removeCallbacks(updateRunnable)
    }
    
    private fun updateClock() {
        val calendar = Calendar.getInstance()
        
        val hour = calendar.get(Calendar.HOUR_OF_DAY)
        val minute = calendar.get(Calendar.MINUTE)
        val second = calendar.get(Calendar.SECOND)
        
        // Format time
        val timeString = if (use24HourFormat) {
            String.format("%02d:%02d", hour, minute)
        } else {
            var hour12 = hour % 12
            if (hour12 == 0) hour12 = 12
            String.format("%d:%02d", hour12, minute)
        }
        
        timeMainText.text = timeString
        
        // Update AM/PM (hide in 24-hour mode)
        if (use24HourFormat) {
            amPmText.visibility = View.GONE
        } else {
            amPmText.visibility = View.VISIBLE
            amPmText.text = if (hour >= 12) "PM" else "AM"
        }
        
        // Update date
        val dateFormat = SimpleDateFormat("MMMM d, yyyy", Locale.getDefault())
        dateText.text = dateFormat.format(calendar.time)
        
        // Update day
        val dayFormat = SimpleDateFormat("EEEE", Locale.getDefault())
        dayText.text = dayFormat.format(calendar.time).uppercase()
        
        // Update seconds progress
        secondsText.text = second.toString()
        secondsProgress.progress = second
    }
}