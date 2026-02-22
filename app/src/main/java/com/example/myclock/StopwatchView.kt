package com.example.myclock

import android.content.Context
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Path
import android.graphics.RectF
import android.util.AttributeSet
import android.view.View
import kotlin.math.cos
import kotlin.math.min
import kotlin.math.sin

class StopwatchView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : View(context, attrs, defStyleAttr) {

    private var centerX = 0f
    private var centerY = 0f
    private var radius = 0f
    private var currentSeconds = 0f
    private val rectF = RectF()

    private val outerTickPaint = Paint().apply {
        color = 0xFFFFFFFF.toInt()
        strokeWidth = 2f
        style = Paint.Style.STROKE
        isAntiAlias = true
    }

    private val majorTickPaint = Paint().apply {
        color = 0xFFFFFFFF.toInt()
        strokeWidth = 4f
        style = Paint.Style.STROKE
        isAntiAlias = true
    }

    private val outerNumberPaint = Paint().apply {
        color = 0xFFFFFFFF.toInt()
        textSize = 32f
        textAlign = Paint.Align.CENTER
        isAntiAlias = true
    }

    private val innerNumberPaint = Paint().apply {
        color = 0xFF999999.toInt()
        textSize = 24f
        textAlign = Paint.Align.CENTER
        isAntiAlias = true
    }

    private val handPaint = Paint().apply {
        color = 0xFFFF6B35.toInt()
        strokeWidth = 8f
        style = Paint.Style.STROKE
        isAntiAlias = true
    }

    private val handFillPaint = Paint().apply {
        color = 0xFFFF6B35.toInt()
        style = Paint.Style.FILL
        isAntiAlias = true
    }

    private val centerDotPaint = Paint().apply {
        color = 0xFFFFFFFF.toInt()
        style = Paint.Style.FILL
        isAntiAlias = true
    }

    override fun onSizeChanged(w: Int, h: Int, oldw: Int, oldh: Int) {
        super.onSizeChanged(w, h, oldw, oldh)
        centerX = w / 2f
        centerY = h / 2f
        val size = min(w, h)
        radius = size / 2f * 0.75f
        
        val scale = radius / 300f
        outerNumberPaint.textSize = 32f * scale
        innerNumberPaint.textSize = 24f * scale
        handPaint.strokeWidth = 8f * scale
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        drawTicks(canvas)
        drawNumbers(canvas)
        drawHand(canvas)
    }

    private fun drawTicks(canvas: Canvas) {
        for (i in 0 until 60) {
            val angle = Math.toRadians((i * 6 - 90).toDouble())
            val isMajor = i % 5 == 0
            val paint = if (isMajor) majorTickPaint else outerTickPaint
            val startRadius = if (isMajor) radius * 0.85f else radius * 0.90f
            val endRadius = radius
            
            val startX = centerX + startRadius * cos(angle).toFloat()
            val startY = centerY + startRadius * sin(angle).toFloat()
            val endX = centerX + endRadius * cos(angle).toFloat()
            val endY = centerY + endRadius * sin(angle).toFloat()
            
            canvas.drawLine(startX, startY, endX, endY, paint)
        }
    }

    private fun drawNumbers(canvas: Canvas) {
        for (i in 0..11) {
            val number = i * 5
            val angle = Math.toRadians((number * 6 - 90).toDouble())
            val textRadius = radius * 0.7f
            val x = centerX + textRadius * cos(angle).toFloat()
            val y = centerY + textRadius * sin(angle).toFloat() - (outerNumberPaint.descent() + outerNumberPaint.ascent()) / 2
            canvas.drawText(number.toString(), x, y, outerNumberPaint)
        }
        
        for (i in 0..5) {
            val number = i * 5
            val angle = Math.toRadians((number * 6 - 90).toDouble())
            val textRadius = radius * 0.5f
            val x = centerX + textRadius * cos(angle).toFloat()
            val y = centerY + textRadius * sin(angle).toFloat() - (innerNumberPaint.descent() + innerNumberPaint.ascent()) / 2
            canvas.drawText(number.toString(), x, y, innerNumberPaint)
        }
    }

    private fun drawHand(canvas: Canvas) {
        val angle = Math.toRadians((currentSeconds * 6 - 90).toDouble())
        val handLength = radius * 0.75f
        val endX = centerX + handLength * cos(angle).toFloat()
        val endY = centerY + handLength * sin(angle).toFloat()
        
        canvas.drawLine(centerX, centerY, endX, endY, handPaint)
        
        val arrowPath = Path()
        val arrowSize = 20f * (radius / 300f)
        val backAngle1 = angle + Math.toRadians(150.0)
        val backAngle2 = angle - Math.toRadians(150.0)
        arrowPath.moveTo(endX, endY)
        arrowPath.lineTo(
            (endX + arrowSize * cos(backAngle1)).toFloat(),
            (endY + arrowSize * sin(backAngle1)).toFloat()
        )
        arrowPath.lineTo(
            (endX + arrowSize * cos(backAngle2)).toFloat(),
            (endY + arrowSize * sin(backAngle2)).toFloat()
        )
        arrowPath.close()
        canvas.drawPath(arrowPath, handFillPaint)
        
        canvas.drawCircle(centerX, centerY, 12f * (radius / 300f), handFillPaint)
        canvas.drawCircle(centerX, centerY, 4f * (radius / 300f), centerDotPaint)
    }

    fun setTime(millis: Long) {
        currentSeconds = (millis / 1000f) % 60
        invalidate()
    }
}
