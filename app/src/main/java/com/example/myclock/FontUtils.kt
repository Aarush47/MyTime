package com.example.myclock

import android.content.Context
import android.graphics.Typeface

object FontUtils {
    private var coolveticaFont: Typeface? = null
    
    fun getCoolveticaFont(context: Context): Typeface {
        if (coolveticaFont == null) {
            coolveticaFont = Typeface.createFromAsset(context.assets, "fonts/coolvetica.ttf")
        }
        return coolveticaFont!!
    }
}
