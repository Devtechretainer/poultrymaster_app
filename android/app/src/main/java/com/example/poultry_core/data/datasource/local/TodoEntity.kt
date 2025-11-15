package com.example.poultry_core.data.datasource.local

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.example.poultry_core.domain.model.Todo

/**
 * Room entity for local database storage
 * Maps domain model to database representation
 */
@Entity(tableName = "todos")
data class TodoEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Long? = null,
    val title: String,
    val description: String = "",
    val isCompleted: Boolean = false,
    val createdAt: Long = System.currentTimeMillis()
) {
    fun toDomain(): Todo {
        return Todo(
            id = id,
            title = title,
            description = description,
            isCompleted = isCompleted,
            createdAt = createdAt
        )
    }
}

fun Todo.toEntity(): TodoEntity {
    return TodoEntity(
        id = id,
        title = title,
        description = description,
        isCompleted = isCompleted,
        createdAt = createdAt
    )
}

