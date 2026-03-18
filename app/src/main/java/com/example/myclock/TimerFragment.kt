package com.example.myclock

import android.os.Bundle
import android.os.CountDownTimer
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import androidx.fragment.app.Fragment

class TimerFragment : Fragment() {
    
    private lateinit var timerDisplay: TextView
    private lateinit var timerLabel: TextView
    private lateinit var preset1Min: Button
    private lateinit var preset5Min: Button
    private lateinit var preset10Min: Button
    private lateinit var preset15Min: Button
    private lateinit var preset30Min: Button
    private lateinit var preset1Hour: Button
    private lateinit var timerStartBtn: Button
    private lateinit var timerResetBtn: Button
    
    private val handler = Handler(Looper.getMainLooper())
    private var countDownTimer: CountDownTimer? = null
    private var timeRemaining: Long = 0L
    private var timerDuration: Long = 0L
    private var isRunning = false
    private val presets = listOf(
        1L * 60 * 1000,      // 1 min
        5L * 60 * 1000,      // 5 min
        10L * 60 * 1000,     // 10 min
        15L * 60 * 1000,     // 15 min
        30L * 60 * 1000,     // 30 min
        60L * 60 * 1000      // 1 hour
    )
    
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_timer, container, false)
    }
    
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        
        timerDisplay = view.findViewById(R.id.timerDisplay)
        timerLabel = view.findViewById(R.id.timerLabel)
        preset1Min = view.findViewById(R.id.preset1min)
        preset5Min = view.findViewById(R.id.preset5min)
        preset10Min = view.findViewById(R.id.preset10min)
        preset15Min = view.findViewById(R.id.preset15min)
        preset30Min = view.findViewById(R.id.preset30min)
        preset1Hour = view.findViewById(R.id.preset1hour)
        timerStartBtn = view.findViewById(R.id.timerStartBtn)
        timerResetBtn = view.findViewById(R.id.timerResetBtn)
        
        // Apply Coolvetica font to timer display
        timerDisplay.typeface = FontUtils.getCoolveticaFont(requireContext())
        
        setupPresetButtons()
        
        timerStartBtn.setOnClickListener {
            if (isRunning) {
                pauseTimer()
                timerStartBtn.text = "Start"
            } else if (timeRemaining > 0) {
                startTimer()
                timerStartBtn.text = "Pause"
            }
        }
        
        timerResetBtn.setOnClickListener {
            resetTimer()
        }
        
        updateDisplay()
    }
    
    private fun setupPresetButtons() {
        val buttons = listOf(preset1Min, preset5Min, preset10Min, preset15Min, preset30Min, preset1Hour)
        buttons.forEachIndexed { index, button ->
            button.setOnClickListener {
                if (!isRunning) {
                    timeRemaining = presets[index]
                    timerDuration = timeRemaining
                    updateDisplay()
                    timerStartBtn.isEnabled = true
                }
            }
        }
    }
    
    private fun startTimer() {
        if (isRunning || timeRemaining <= 0) return
        
        isRunning = true
        timerStartBtn.isEnabled = true
        timerResetBtn.isEnabled = true
        
        countDownTimer = object : CountDownTimer(timeRemaining, 100) {
            override fun onTick(millisUntilFinished: Long) {
                timeRemaining = millisUntilFinished
                updateDisplay()
            }
            
            override fun onFinish() {
                timeRemaining = 0L
                isRunning = false
                timerDisplay.text = "00:00"
                timerLabel.text = "COMPLETED"
                timerStartBtn.text = "Start"
            }
        }
        countDownTimer?.start()
    }
    
    private fun pauseTimer() {
        countDownTimer?.cancel()
        isRunning = false
    }
    
    private fun resetTimer() {
        countDownTimer?.cancel()
        isRunning = false
        timeRemaining = 0L
        timerDuration = 0L
        timerLabel.text = "REMAINING"
        timerStartBtn.text = "Start"
        updateDisplay()
    }
    
    private fun updateDisplay() {
        val minutes = (timeRemaining / 1000) / 60
        val seconds = (timeRemaining / 1000) % 60
        timerDisplay.text = String.format("%02d:%02d", minutes, seconds)
    }
    
    override fun onPause() {
        super.onPause()
        if (isRunning) {
            pauseTimer()
            timerStartBtn.text = "Start"
        }
    }
    
    override fun onDestroyView() {
        super.onDestroyView()
        countDownTimer?.cancel()
    }
}
