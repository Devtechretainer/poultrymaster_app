package com.example.poultry_core.presentation.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.poultry_core.domain.model.Todo
import com.example.poultry_core.domain.usecase.*
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * UI State for Todo screen
 * Represents all possible states the UI can be in
 */
data class TodoUiState(
    val todos: List<Todo> = emptyList(),
    val isLoading: Boolean = false,
    val error: String? = null,
    val showAddDialog: Boolean = false
)

/**
 * ViewModel for Todo feature
 * Handles UI logic and state management
 * Connects presentation layer with domain layer through use cases
 */
@HiltViewModel
class TodoViewModel @Inject constructor(
    private val getTodosUseCase: GetTodosUseCase,
    private val addTodoUseCase: AddTodoUseCase,
    private val toggleTodoUseCase: ToggleTodoUseCase,
    private val deleteTodoUseCase: DeleteTodoUseCase
) : ViewModel() {

    private val _uiState = MutableStateFlow(TodoUiState())
    val uiState: StateFlow<TodoUiState> = _uiState.asStateFlow()

    init {
        loadTodos()
    }

    private fun loadTodos() {
        viewModelScope.launch {
            _uiState.update { it.copy(isLoading = true, error = null) }
            
            getTodosUseCase()
                .catch { exception ->
                    _uiState.update { 
                        it.copy(
                            isLoading = false,
                            error = exception.message ?: "An error occurred"
                        )
                    }
                }
                .collect { todos ->
                    _uiState.update { 
                        it.copy(
                            todos = todos,
                            isLoading = false
                        )
                    }
                }
        }
    }

    fun addTodo(title: String, description: String = "") {
        viewModelScope.launch {
            addTodoUseCase(title, description)
                .collect { result ->
                    result.onSuccess {
                        _uiState.update { it.copy(showAddDialog = false) }
                    }.onFailure { exception ->
                        _uiState.update { 
                            it.copy(
                                error = exception.message ?: "Failed to add todo"
                            )
                        }
                    }
                }
        }
    }

    fun toggleTodo(todo: Todo) {
        viewModelScope.launch {
            toggleTodoUseCase(todo)
                .collect { result ->
                    result.onFailure { exception ->
                        _uiState.update { 
                            it.copy(
                                error = exception.message ?: "Failed to update todo"
                            )
                        }
                    }
                }
        }
    }

    fun deleteTodo(todo: Todo) {
        viewModelScope.launch {
            deleteTodoUseCase(todo)
                .collect { result ->
                    result.onFailure { exception ->
                        _uiState.update { 
                            it.copy(
                                error = exception.message ?: "Failed to delete todo"
                            )
                        }
                    }
                }
        }
    }

    fun showAddDialog() {
        _uiState.update { it.copy(showAddDialog = true) }
    }

    fun hideAddDialog() {
        _uiState.update { it.copy(showAddDialog = false) }
    }

    fun clearError() {
        _uiState.update { it.copy(error = null) }
    }
}

