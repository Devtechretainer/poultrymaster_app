package com.example.poultry_core.domain.usecase

import com.example.poultry_core.domain.model.Todo
import com.example.poultry_core.domain.repository.TodoRepository
import kotlinx.coroutines.flow.Flow

/**
 * Use case for deleting a todo
 * Encapsulates the business logic for removing todos
 */
class DeleteTodoUseCase(
    private val repository: TodoRepository
) {
    suspend operator fun invoke(todo: Todo): Flow<Result<Unit>> {
        return repository.deleteTodo(todo)
    }
}

