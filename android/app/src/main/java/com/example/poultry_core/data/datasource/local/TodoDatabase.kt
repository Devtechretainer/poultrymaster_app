package com.example.poultry_core.data.datasource.local

import androidx.room.Database
import androidx.room.RoomDatabase

/**
 * Room database for Todo storage
 * Hilt will manage the database instance through DatabaseModule
 */
@Database(
    entities = [TodoEntity::class],
    version = 1,
    exportSchema = false
)
abstract class TodoDatabase : RoomDatabase() {
    abstract fun todoDao(): TodoDao
}

