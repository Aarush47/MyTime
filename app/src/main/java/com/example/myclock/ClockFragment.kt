package com.example.myclock

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import java.text.SimpleDateFormat
import java.util.*

class ClockFragment : Fragment() {
    
    private lateinit var hour1: TextView
    private lateinit var hour2: TextView
    private lateinit var minute1: TextView
    private lateinit var minute2: TextView
    private lateinit var second1: TextView
    private lateinit var second2: TextView
    private lateinit var amPm: TextView
    private lateinit var dateText: TextView
    
    private val handler = Handler(Looper.getMainLooper())
    private val updateRunnable = object : Runnable {
        override fun run() {
            updateClock()
            handler.postDelayed(this, 1000)
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
        
        hour1 = view.findViewById(R.id.hour1)
        hour2 = view.findViewById(R.id.hour2)
        minute1 = view.findViewById(R.id.minute1)
        minute2 = view.findViewById(R.id.minute2)
        second1 = view.findViewById(R.id.second1)
        second2 = view.findViewById(R.id.second2)
        amPm = view.findViewById(R.id.amPm)
        dateText = view.findViewById(R.id.dateText)
        
        // Start the clock immediately
        updateClock()
        handler.post(updateRunnable)
    }
    
    override fun onResume() {
        super.onResume()
        // Ensure handler is running when fragment resumes
        handler.removeCallbacks(updateRunnable)
        handler.post(updateRunnable)
    }
    
    override fun onPause() {
        super.onPause()
        handler.removeCallbacks(updateRunnable)
    }
    
    private fun updateClock() {
        val calendar = Calendar.getInstance()
        
        // 12-hour format
        var hour = calendar.get(Calendar.HOUR)
        if (hour == 0) hour = 12
        val minute = calendar.get(Calendar.MINUTE)
        val second = calendar.get(Calendar.SECOND)
        val amPmValue = if (calendar.get(Calendar.AM_PM) == Calendar.AM) "AM" else "PM"
        
        // Update with animation
        updateDigit(hour1, hour / 10)
        updateDigit(hour2, hour % 10)
        updateDigit(minute1, minute / 10)
        updateDigit(minute2, minute % 10)
        updateDigit(second1, second / 10)
        updateDigit(second2, second % 10)
        amPm.text = amPmValue
        
        // Update date
        val dateFormat = SimpleDateFormat("EEEE, MMMM d", Locale.getDefault())
        dateText.text = dateFormat.format(calendar.time).uppercase()
    }
    
    private fun updateDigit(textView: TextView, value: Int) {
        val newValue = value.toString()
        if (textView.text != newValue) {
            textView.animate()
                .alpha(0f)
                .setDuration(150)
                .withEndAction {
                    textView.text = newValue
                    textView.animate().alpha(1f).setDuration(150).start()
                }
                .start()
        }
    }
}