package com.example.poultry_core.data.repository

import com.example.poultry_core.data.datasource.local.LocalTodoDataSource
import com.example.poultry_core.domain.model.Todo
import com.example.poultry_core.domain.repository.TodoRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import javax.inject.Inject

/**
 * Repository implementation in the data layer
 * Coordinates between different data sources (local, remote)
 * Implements the domain repository interface
 */
class TodoRepositoryImpl @Inject constructor(
    private val localDataSource: LocalTodoDataSource
) : TodoRepository {

    override fun getTodos(): Flow<List<Todo>> {
        return localDataSource.getTodos()
    }

    override suspend fun addTodo(todo: Todo): Flow<Result<Unit>> {
        return flow {
            try {
                localDataSource.addTodo(todo)
                emit(Result.success(Unit))
            } catch (e: Exception) {
                emit(Result.failure(e))
            }
        }
    }

    override suspend fun updateTodo(todo: Todo): Flow<Result<Unit>> {
        return flow {
            try {
                localDataSource.updateTodo(todo)
                emit(Result.success(Unit))
            } catch (e: Exception) {
                emit(Result.failure(e))
            }
        }
    }

    override suspend fun deleteTodo(todo: Todo): Flow<Result<Unit>> {
        return flow {
            try {
                localDataSource.deleteTodo(todo)
                emit(Result.success(Unit))
            } catch (e: Exception) {
                emit(Result.failure(e))
            }
        }
    }
}

