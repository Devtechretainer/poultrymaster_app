package com.example.poultry_core

import android.app.Application
import dagger.hilt.android.HiltAndroidApp

/**
 * Application class annotated with @HiltAndroidApp
 * This enables Hilt dependency injection throughout the app
 */
@HiltAndroidApp
class PoultryCoreApplication : Application()

