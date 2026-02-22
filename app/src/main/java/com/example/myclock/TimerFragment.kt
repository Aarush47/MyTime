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
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView

class TimerFragment : Fragment() {
    
    private lateinit var stopwatchView: StopwatchView
    private lateinit var timeDisplay: TextView
    private lateinit var buttonStartStop: Button
    private lateinit var buttonLap: Button
    private lateinit var lapTimesRecycler: RecyclerView
    
    private val handler = Handler(Looper.getMainLooper())
    private var startTime = 0L
    private var elapsedTime = 0L
    private var isRunning = false
    private val lapTimes = mutableListOf<LapTime>()
    private lateinit var lapAdapter: LapAdapter
    
    private val updateRunnable = object : Runnable {
        override fun run() {
            if (isRunning) {
                elapsedTime = SystemClock.elapsedRealtime() - startTime
                updateDisplay()
                handler.postDelayed(this, 10) // Update every 10ms for smooth animation
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
        lapTimesRecycler = view.findViewById(R.id.lapTimesRecycler)
        
        setupRecyclerView()
        
        buttonStartStop.setOnClickListener {
            if (isRunning) {
                stop()
            } else {
                start()
            }
        }
        
        buttonLap.setOnClickListener {
            if (isRunning) {
                addLap()
            } else if (elapsedTime > 0) {
                reset()
            }
        }
    }
    
    private fun setupRecyclerView() {
        lapAdapter = LapAdapter(lapTimes)
        lapTimesRecycler.layoutManager = LinearLayoutManager(context)
        lapTimesRecycler.adapter = lapAdapter
        lapTimesRecycler.visibility = View.GONE // Hide initially until laps are added
    }
    
    private fun start() {
        startTime = SystemClock.elapsedRealtime() - elapsedTime
        isRunning = true
        buttonStartStop.text = "Stop"
        buttonStartStop.setBackgroundResource(R.drawable.circular_button_red)
        buttonLap.text = "Lap"
        buttonLap.isEnabled = true
        handler.post(updateRunnable)
    }
    
    private fun stop() {
        isRunning = false
        buttonStartStop.text = "Start"
        buttonStartStop.setBackgroundResource(R.drawable.circular_button_green)
        buttonLap.text = "Reset"
        handler.removeCallbacks(updateRunnable)
    }
    
    private fun reset() {
        elapsedTime = 0L
        lapTimes.clear()
        lapAdapter.notifyDataSetChanged()
        lapTimesRecycler.visibility = View.GONE
        buttonLap.isEnabled = false
        updateDisplay()
    }
    
    private fun addLap() {
        val currentTotal = elapsedTime
        val lapTime = if (lapTimes.isEmpty()) {
            currentTotal
        } else {
            currentTotal - lapTimes.last().totalTime
        }
        
        lapTimes.add(0, LapTime(lapTimes.size + 1, lapTime, currentTotal))
        lapAdapter.notifyItemInserted(0)
        lapTimesRecycler.visibility = View.VISIBLE
        lapTimesRecycler.scrollToPosition(0)
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
    
    override fun onResume() {
        super.onResume()
        if (isRunning) {
            handler.post(updateRunnable)
        }
    }
    
    data class LapTime(
        val lapNumber: Int,
        val lapTime: Long,
        val totalTime: Long
    )
    
    class LapAdapter(private val laps: List<LapTime>) : RecyclerView.Adapter<LapAdapter.ViewHolder>() {
        
        class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
            val lapNumber: TextView = view.findViewById(R.id.lapNumber)
            val lapTime: TextView = view.findViewById(R.id.lapTime)
            val totalTime: TextView = view.findViewById(R.id.totalTime)
        }
        
        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
            val view = LayoutInflater.from(parent.context)
                .inflate(R.layout.lap_item, parent, false)
            return ViewHolder(view)
        }
        
        override fun onBindViewHolder(holder: ViewHolder, position: Int) {
            val lap = laps[position]
            holder.lapNumber.text = "Lap ${lap.lapNumber}"
            holder.lapTime.text = formatTime(lap.lapTime)
            holder.totalTime.text = formatTime(lap.totalTime)
        }
        
        override fun getItemCount() = laps.size
        
        private fun formatTime(millis: Long): String {
            val minutes = (millis / 60000).toInt()
            val seconds = ((millis % 60000) / 1000).toInt()
            val centiseconds = ((millis % 1000) / 10).toInt()
            return String.format("%02d:%02d.%02d", minutes, seconds, centiseconds)
        }
    }
}
