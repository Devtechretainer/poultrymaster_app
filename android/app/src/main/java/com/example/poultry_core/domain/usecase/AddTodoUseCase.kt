package com.example.poultry_core.domain.usecase

import com.example.poultry_core.domain.model.Todo
import com.example.poultry_core.domain.repository.TodoRepository
import kotlinx.coroutines.flow.Flow

/**
 * Use case for adding a new todo
 * Encapsulates the business logic for creating todos
 */
class AddTodoUseCase(
    private val repository: TodoRepository
) {
    suspend operator fun invoke(title: String, description: String = ""): Flow<Result<Unit>> {
        return if (title.isBlank()) {
            kotlinx.coroutines.flow.flowOf(Result.failure(IllegalArgumentException("Title cannot be empty")))
        } else {
            repository.addTodo(Todo(title = title.trim(), description = description.trim()))
        }
    }
}

