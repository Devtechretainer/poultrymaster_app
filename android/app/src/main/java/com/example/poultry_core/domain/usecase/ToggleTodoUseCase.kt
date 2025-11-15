package com.example.poultry_core.domain.usecase

import com.example.poultry_core.domain.model.Todo
import com.example.poultry_core.domain.repository.TodoRepository
import kotlinx.coroutines.flow.Flow

/**
 * Use case for toggling todo completion status
 * Encapsulates the business logic for updating todo state
 */
class ToggleTodoUseCase(
    private val repository: TodoRepository
) {
    suspend operator fun invoke(todo: Todo): Flow<Result<Unit>> {
        val updatedTodo = todo.copy(isCompleted = !todo.isCompleted)
        return repository.updateTodo(updatedTodo)
    }
}

