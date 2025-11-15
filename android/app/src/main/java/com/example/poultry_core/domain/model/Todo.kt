package com.example.poultry_core.domain.model

/**
 * Domain model for Todo
 * This is the core business entity - pure Kotlin data class
 * No Android dependencies, making it testable and reusable
 */
data class Todo(
    val id: Long? = null,
    val title: String,
    val description: String = "",
    val isCompleted: Boolean = false,
    val createdAt: Long = System.currentTimeMillis()
)

