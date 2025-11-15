package com.example.poultry_core.di

import com.example.poultry_core.data.datasource.local.LocalTodoDataSource
import com.example.poultry_core.data.repository.TodoRepositoryImpl
import com.example.poultry_core.domain.repository.TodoRepository
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

/**
 * Hilt module for providing repository implementations
 * Binds repository interface to its implementation
 */
@Module
@InstallIn(SingletonComponent::class)
abstract class RepositoryModule {

    @Binds
    @Singleton
    abstract fun bindTodoRepository(
        todoRepositoryImpl: TodoRepositoryImpl
    ): TodoRepository
}

