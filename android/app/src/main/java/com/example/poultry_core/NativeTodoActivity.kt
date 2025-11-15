package com.example.poultry_core

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import com.example.poultry_core.presentation.ui.TodoScreen
import dagger.hilt.android.AndroidEntryPoint

/**
 * Native Android Activity using Jetpack Compose
 * This is a separate Activity that can be launched from Flutter if needed
 * Annotated with @AndroidEntryPoint for Hilt dependency injection
 */
@AndroidEntryPoint
class NativeTodoActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    TodoScreen()
                }
            }
        }
    }
    
    companion object {
        /**
         * Creates an intent to launch this activity from Flutter
         */
        fun createIntent(context: android.content.Context): Intent {
            return Intent(context, NativeTodoActivity::class.java)
        }
    }
}

