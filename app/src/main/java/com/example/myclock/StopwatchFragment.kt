package com.example.myclock

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import androidx.fragment.app.Fragment

class StopwatchFragment : Fragment() {
    
    private lateinit var stopwatchView: StopwatchView
    private lateinit var timeDisplay: TextView
    private lateinit var buttonStartStop: Button
    private lateinit var buttonLap: Button
    
    private val handler = Handler(Looper.getMainLooper())
    private var startTime = 0L
    private var elapsedTime = 0L
    private var isRunning = false
    
    private val updateRunnable = object : Runnable {
        override fun run() {
            if (isRunning) {
                elapsedTime = SystemClock.elapsedRealtime() - startTime
                updateDisplay()
                handler.postDelayed(this, 10)
            }
        }
    }
    
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_stopwatch, container, false)
    }
    
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        
        stopwatchView = view.findViewById(R.id.stopwatchView)
        timeDisplay = view.findViewById(R.id.timeDisplay)
        buttonStartStop = view.findViewById(R.id.buttonStartStop)
        buttonLap = view.findViewById(R.id.buttonLap)
        
        // Apply Coolvetica font to time display
        timeDisplay.typeface = FontUtils.getCoolveticaFont(requireContext())
        
        buttonStartStop.setOnClickListener {
            if (isRunning) {
                stop()
            } else {
                start()
            }
        }
        
        buttonLap.setOnClickListener {
            if (isRunning) {
                // lap functionality
            } else if (elapsedTime > 0) {
                reset()
            }
        }
    }
    
    private fun start() {
        startTime = SystemClock.elapsedRealtime() - elapsedTime
        isRunning = true
        buttonStartStop.text = "Stop"
        buttonLap.text = "Lap"
        handler.post(updateRunnable)
    }
    
    private fun stop() {
        isRunning = false
        buttonStartStop.text = "Start"
        buttonLap.text = "Reset"
        handler.removeCallbacks(updateRunnable)
    }
    
    private fun reset() {
        elapsedTime = 0L
        buttonLap.text = "Lap"
        buttonLap.isEnabled = false
        updateDisplay()
    }
    
    private fun updateDisplay() {
        val minutes = (elapsedTime / 60000).toInt()
        val seconds = ((elapsedTime % 60000) / 1000).toInt()
        val centiseconds = ((elapsedTime % 1000) / 10).toInt()
        
        timeDisplay.text = String.format("%02d:%02d.%02d", minutes, seconds, centiseconds)
        stopwatchView.setTime(elapsedTime)
    }
    
    override fun onPause() {
        super.onPause()
        handler.removeCallbacks(updateRunnable)
    }
}
