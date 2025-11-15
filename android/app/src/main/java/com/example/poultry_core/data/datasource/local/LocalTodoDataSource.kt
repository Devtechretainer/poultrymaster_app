package com.example.poultry_core.data.datasource.local

import com.example.poultry_core.domain.model.Todo
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

/**
 * Local data source implementation using Room
 * Handles all local database operations
 */
class LocalTodoDataSource(
    private val todoDao: TodoDao
) {
    fun getTodos(): Flow<List<Todo>> {
        return todoDao.getAllTodos().map { entities ->
            entities.map { it.toDomain() }
        }
    }

    suspend fun addTodo(todo: Todo): Long {
        return todoDao.insertTodo(todo.toEntity())
    }

    suspend fun updateTodo(todo: Todo) {
        todo.toEntity().let { entity ->
            todoDao.updateTodo(entity)
        }
    }

    suspend fun deleteTodo(todo: Todo) {
        todo.toEntity().let { entity ->
            todoDao.deleteTodo(entity)
        }
    }
}

