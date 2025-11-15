package com.example.poultry_core.di

import com.example.poultry_core.domain.repository.TodoRepository
import com.example.poultry_core.domain.usecase.*
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.components.ViewModelComponent
import dagger.hilt.android.scopes.ViewModelScoped

/**
 * Hilt module for providing use cases
 * Provides use case instances scoped to ViewModels
 */
@Module
@InstallIn(ViewModelComponent::class)
object UseCaseModule {

    @Provides
    @ViewModelScoped
    fun provideGetTodosUseCase(repository: TodoRepository): GetTodosUseCase {
        return GetTodosUseCase(repository)
    }

    @Provides
    @ViewModelScoped
    fun provideAddTodoUseCase(repository: TodoRepository): AddTodoUseCase {
        return AddTodoUseCase(repository)
    }

    @Provides
    @ViewModelScoped
    fun provideToggleTodoUseCase(repository: TodoRepository): ToggleTodoUseCase {
        return ToggleTodoUseCase(repository)
    }

    @Provides
    @ViewModelScoped
    fun provideDeleteTodoUseCase(repository: TodoRepository): DeleteTodoUseCase {
        return DeleteTodoUseCase(repository)
    }
}

