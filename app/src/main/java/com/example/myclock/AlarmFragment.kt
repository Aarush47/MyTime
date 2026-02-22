package com.example.myclock

import android.app.TimePickerDialog
import android.os.Build
import android.os.Bundle
import android.os.VibrationEffect
import android.os.Vibrator
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.appcompat.app.AlertDialog
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.floatingactionbutton.FloatingActionButton
import java.util.*

class AlarmFragment : Fragment() {
    
    private lateinit var alarmManager: AlarmManager
    private lateinit var alarmScheduler: AlarmScheduler
    private lateinit var recyclerView: RecyclerView
    private lateinit var emptyView: LinearLayout
    private lateinit var adapter: AlarmAdapter
    private var alarms = mutableListOf<AlarmData>()
    private lateinit var vibrator: Vibrator
    
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_alarm, container, false)
    }
    
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        
        alarmManager = AlarmManager(requireContext())
        alarmScheduler = AlarmScheduler(requireContext())
        vibrator = ContextCompat.getSystemService(requireContext(), Vibrator::class.java)!!
        recyclerView = view.findViewById(R.id.alarmRecyclerView)
        emptyView = view.findViewById(R.id.emptyView)
        val fabAdd = view.findViewById<FloatingActionButton>(R.id.fabAddAlarm)
        
        setupRecyclerView()
        loadAlarms()
        
        fabAdd.setOnClickListener {
            vibrateClick()
            showAddAlarmDialog()
        }
    }
    
    private fun setupRecyclerView() {
        adapter = AlarmAdapter(
            alarms,
            onToggle = { alarm ->
                vibrateClick()
                alarmManager.toggleAlarm(alarm.id)
                if (alarm.isEnabled) {
                    alarmScheduler.cancelAlarm(alarm.id)
                } else {
                    val updatedAlarm = alarm.copy(isEnabled = true)
                    alarmScheduler.scheduleAlarm(updatedAlarm)
                }
                loadAlarms()
            },
            onDelete = { alarm ->
                vibrateClick()
                showDeleteConfirmation(alarm)
            },
            onEdit = { alarm ->
                vibrateClick()
                showEditAlarmDialog(alarm)
            }
        )
        recyclerView.layoutManager = LinearLayoutManager(context)
        recyclerView.adapter = adapter
    }
    
    private fun loadAlarms() {
        alarms.clear()
        alarms.addAll(alarmManager.loadAlarms().sortedBy { it.hour * 60 + it.minute })
        adapter.notifyDataSetChanged()
        
        if (alarms.isEmpty()) {
            recyclerView.visibility = View.GONE
            emptyView.visibility = View.VISIBLE
        } else {
            recyclerView.visibility = View.VISIBLE
            emptyView.visibility = View.GONE
        }
    }
    
    private fun showAddAlarmDialog() {
        val calendar = Calendar.getInstance()
        TimePickerDialog(
            requireContext(),
            { _, hour, minute ->
                showAlarmDetailsDialog(hour, minute, null)
            },
            calendar.get(Calendar.HOUR_OF_DAY),
            calendar.get(Calendar.MINUTE),
            false
        ).show()
    }
    
    private fun showEditAlarmDialog(alarm: AlarmData) {
        TimePickerDialog(
            requireContext(),
            { _, hour, minute ->
                showAlarmDetailsDialog(hour, minute, alarm)
            },
            alarm.hour,
            alarm.minute,
            false
        ).show()
    }
    
    private fun showAlarmDetailsDialog(hour: Int, minute: Int, existingAlarm: AlarmData?) {
        val dialogView = layoutInflater.inflate(R.layout.dialog_alarm_details, null)
        val labelInput = dialogView.findViewById<EditText>(R.id.alarmLabel)
        val repeatContainer = dialogView.findViewById<LinearLayout>(R.id.repeatDaysContainer)
        
        existingAlarm?.let {
            labelInput.setText(it.label)
        }
        
        val dayButtons = mutableListOf<CheckBox>()
        val days = listOf("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
        days.forEachIndexed { index, day ->
            val checkbox = CheckBox(requireContext()).apply {
                text = day
                textSize = 14f
                setTextColor(0xFFFFFFFF.toInt())
                isChecked = existingAlarm?.repeatDays?.contains(index + 1) ?: false
            }
            dayButtons.add(checkbox)
            repeatContainer.addView(checkbox)
        }
        
        AlertDialog.Builder(requireContext())
            .setTitle(if (existingAlarm == null) "New Alarm" else "Edit Alarm")
            .setView(dialogView)
            .setPositiveButton("Save") { _, _ ->
                val label = labelInput.text.toString()
                val repeatDays = dayButtons.mapIndexedNotNull { index, cb ->
                    if (cb.isChecked) index + 1 else null
                }
                
                val alarm = AlarmData(
                    id = existingAlarm?.id ?: UUID.randomUUID().toString(),
                    hour = hour,
                    minute = minute,
                    isEnabled = existingAlarm?.isEnabled ?: true,
                    label = label,
                    repeatDays = repeatDays
                )
                
                if (existingAlarm == null) {
                    alarmManager.addAlarm(alarm)
                } else {
                    alarmManager.updateAlarm(alarm)
                }
                
                // Schedule the alarm if enabled
                if (alarm.isEnabled) {
                    alarmScheduler.scheduleAlarm(alarm)
                }
                
                loadAlarms()
            }
            .setNegativeButton("Cancel", null)
            .show()
    }
    
    private fun showDeleteConfirmation(alarm: AlarmData) {
        AlertDialog.Builder(requireContext())
            .setTitle("Delete Alarm")
            .setMessage("Are you sure you want to delete this alarm?")
            .setPositiveButton("Delete") { _, _ ->
                vibrateClick()
                alarmManager.deleteAlarm(alarm.id)
                alarmScheduler.cancelAlarm(alarm.id)
                loadAlarms()
            }
            .setNegativeButton("Cancel", null)
            .show()
    }
    
    private fun vibrateClick() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator.vibrate(VibrationEffect.createOneShot(50, VibrationEffect.DEFAULT_AMPLITUDE))
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(50)
        }
    }
}

class AlarmAdapter(
    private val alarms: List<AlarmData>,
    private val onToggle: (AlarmData) -> Unit,
    private val onDelete: (AlarmData) -> Unit,
    private val onEdit: (AlarmData) -> Unit
) : RecyclerView.Adapter<AlarmAdapter.ViewHolder>() {
    
    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val timeText: TextView = view.findViewById(R.id.alarmTime)
        val labelText: TextView = view.findViewById(R.id.alarmLabel)
        val repeatText: TextView = view.findViewById(R.id.alarmRepeat)
        val toggleSwitch: Switch = view.findViewById(R.id.alarmSwitch)
        val deleteButton: ImageButton = view.findViewById(R.id.deleteButton)
        val container: View = view.findViewById(R.id.alarmContainer)
    }
    
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.alarm_item, parent, false)
        return ViewHolder(view)
    }
    
    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val alarm = alarms[position]
        
        holder.timeText.text = alarm.getFormattedTime()
        holder.labelText.text = if (alarm.label.isEmpty()) "Alarm" else alarm.label
        holder.labelText.visibility = if (alarm.label.isEmpty()) View.GONE else View.VISIBLE
        holder.repeatText.text = alarm.getRepeatText()
        holder.toggleSwitch.isChecked = alarm.isEnabled
        
        holder.timeText.alpha = if (alarm.isEnabled) 1f else 0.4f
        holder.labelText.alpha = if (alarm.isEnabled) 1f else 0.4f
        holder.repeatText.alpha = if (alarm.isEnabled) 0.6f else 0.3f
        
        holder.toggleSwitch.setOnCheckedChangeListener { _, _ ->
            onToggle(alarm)
        }
        
        holder.deleteButton.setOnClickListener {
            onDelete(alarm)
        }
        
        holder.container.setOnClickListener {
            onEdit(alarm)
        }
    }
    
    override fun getItemCount() = alarms.size
}