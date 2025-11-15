package com.example.poultry_core.di

import android.content.Context
import androidx.room.Room
import com.example.poultry_core.data.datasource.local.LocalTodoDataSource
import com.example.poultry_core.data.datasource.local.TodoDao
import com.example.poultry_core.data.datasource.local.TodoDatabase
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

/**
 * Hilt module for providing database dependencies
 * Provides Room database, DAO, and data source instances
 */
@Module
@InstallIn(SingletonComponent::class)
object DatabaseModule {

    @Provides
    @Singleton
    fun provideTodoDatabase(
        @ApplicationContext context: Context
    ): TodoDatabase {
        return Room.databaseBuilder(
            context,
            TodoDatabase::class.java,
            "todo_database"
        ).build()
    }

    @Provides
    fun provideTodoDao(database: TodoDatabase): TodoDao {
        return database.todoDao()
    }

    @Provides
    fun provideLocalTodoDataSource(todoDao: TodoDao): LocalTodoDataSource {
        return LocalTodoDataSource(todoDao)
    }
}

