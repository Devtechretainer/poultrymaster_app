package com.example.poultry_core.domain.usecase

import com.example.poultry_core.domain.model.Todo
import com.example.poultry_core.domain.repository.TodoRepository
import kotlinx.coroutines.flow.Flow

/**
 * Use case for getting all todos
 * Encapsulates the business logic for retrieving todos
 */
class GetTodosUseCase(
    private val repository: TodoRepository
) {
    operator fun invoke(): Flow<List<Todo>> = repository.getTodos()
}

