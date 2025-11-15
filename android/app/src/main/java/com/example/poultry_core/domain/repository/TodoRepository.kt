package com.example.poultry_core.domain.repository

import com.example.poultry_core.domain.model.Todo
import kotlinx.coroutines.flow.Flow

/**
 * Repository interface in the domain layer
 * Defines the contract for data operations without implementation details
 * This keeps the domain layer independent of data sources
 */
interface TodoRepository {
    fun getTodos(): Flow<List<Todo>>
    suspend fun addTodo(todo: Todo): Flow<Result<Unit>>
    suspend fun updateTodo(todo: Todo): Flow<Result<Unit>>
    suspend fun deleteTodo(todo: Todo): Flow<Result<Unit>>
}

