# Pragmatic Clean Architecture for Flutter

> **Clean Architecture is a principle, not a strict folder structure.** Apply it pragmatically based on your feature complexity.

## 🏗️ Project Structure

```
lib/
├── domain/                         # Domain Layer - Pure business rules
│   ├── entities/                   # Business entities (pure Dart classes)
│   │   └── todo.dart
│   ├── repositories/               # Repository interfaces
│   │   └── todo_repository.dart
│   └── usecases/                   # Use cases (business logic)
│       ├── get_todos_usecase.dart
│       ├── add_todo_usecase.dart
│       ├── toggle_todo_usecase.dart
│       └── delete_todo_usecase.dart
│
├── data/                           # Data Layer - How data is fetched/stored
│   ├── datasources/                # Data sources (only if multiple sources)
│   │   └── local_todo_datasource.dart
│   ├── models/                     # Data models (map to/from domain)
│   │   └── todo_model.dart
│   └── repositories/               # Repository implementations
│       └── todo_repository_impl.dart
│
├── application/                    # Application Layer - State management
│   ├── controllers/                # State controllers (Riverpod StateNotifier)
│   │   └── todo_controller.dart
│   ├── states/                     # Application state classes
│   │   └── todo_state.dart
│   └── providers/                  # Dependency injection providers
│       └── todo_providers.dart
│
└── presentation/                   # Presentation Layer - Pure UI
    ├── screens/                    # Full screens
    │   └── todo_screen.dart
    └── widgets/                    # Reusable widgets
        ├── todo_item.dart
        └── add_todo_dialog.dart
```

## 📋 Layer Responsibilities

### 1️⃣ **Presentation Layer** - Pure UI
- **Screens & Widgets**: Display data, handle user input
- **No business logic**: Only reads from state and calls controller methods
- **No async calls**: All async operations happen in controllers
- **No API calls**: Controllers handle all data operations

```dart
// ✅ GOOD: Reads from state, calls controller
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(todoControllerProvider);
  final controller = ref.read(todoControllerProvider.notifier);
  
  return ListView(
    children: state.todos.map((todo) => TodoItem(todo: todo)).toList(),
  );
}

// ❌ BAD: Direct API calls or business logic in UI
Widget build(BuildContext context) {
  final todos = await api.getTodos(); // ❌ No!
  return ListView(...);
}
```

### 2️⃣ **Application Layer** - State Management
- **Controllers**: Manage state, coordinate use cases
- **States**: Represent UI state (loading, data, errors)
- **Providers**: Dependency injection (Riverpod)

**Rules:**
- ✅ Only manage state and call use cases
- ✅ Never call APIs/data sources directly
- ✅ Handle async operations and errors
- ❌ No business logic (that's in use cases)

```dart
// ✅ GOOD: Controller calls use case
Future<void> addTodo(String title) async {
  state = state.copyWith(isLoading: true);
  try {
    await addTodoUseCase(title); // Calls use case
    await loadTodos();
  } catch (e) {
    state = state.copyWith(error: e.toString());
  }
}

// ❌ BAD: Controller calling repository directly
Future<void> addTodo(String title) async {
  await repository.addTodo(...); // ❌ Skip use case!
}
```

### 3️⃣ **Domain Layer** - Pure Business Rules
- **Entities**: Business data models (pure Dart, no Flutter/API dependencies)
- **Use Cases**: Encapsulate business logic
- **Repository Interfaces**: Define data contracts

**Rules:**
- ✅ Pure Dart - No Flutter, no API dependencies
- ✅ Testable without platform dependencies
- ✅ Reusable across platforms

```dart
// ✅ GOOD: Pure business logic
class AddTodoUseCase {
  Future<Todo> call(String title) {
    if (title.trim().isEmpty) {
      throw ArgumentError('Title cannot be empty'); // Business rule
    }
    return repository.addTodo(Todo(title: title.trim()));
  }
}
```

### 4️⃣ **Data Layer** - Data Management
- **Repository Implementations**: Coordinate data sources
- **Data Sources**: Remote API, local DB, cache
- **Models**: Map between domain entities and storage format

**Rules:**
- ✅ Maps API/DB responses to domain entities
- ✅ Handles data source switching (local/remote)
- ✅ Single source of truth for data

```dart
// ✅ GOOD: Maps between domain and data
class TodoRepositoryImpl implements TodoRepository {
  Future<List<Todo>> getTodos() async {
    final models = await localDataSource.getTodos();
    return models.map((m) => m.toEntity()).toList(); // Map to domain
  }
}
```

## 🎯 Rules of Thumb

### ✅ Entities / Freezed Classes
- Use domain entities for business data
- Freezed classes can replace entities if you don't need separate pure Dart classes
- In this example, we use simple Dart classes (you can use Freezed if preferred)

```dart
// Simple entity (this example)
class Todo {
  final String? id;
  final String title;
  // ...
}

// Or with Freezed (optional)
@freezed
class Todo with _$Todo {
  const factory Todo({
    String? id,
    required String title,
  }) = _Todo;
}
```

### ✅ Repository Interfaces
- **Useful if**: You want to swap data sources easily or enable unit testing with mocks
- **Skip if**: The feature is simple and uses only one data source
- **In this example**: We use interfaces for better testability

### ✅ Application Layer
- **Optional for**: Simple state management
- **Recommended for**: 
  - Handling states (loading, success, error)
  - Orchestrating multiple use cases
  - Managing complex UI state

### ✅ Data Sources
- **Only create separate remote/local datasources if**:
  - You have multiple sources (API + local DB)
  - You need caching
  - You want to switch between sources
- **Otherwise**: Repository can directly handle API calls

```dart
// ✅ If simple: Repository directly calls API
class TodoRepositoryImpl {
  Future<List<Todo>> getTodos() async {
    final response = await http.get(...); // Direct API call
    return parseTodos(response);
  }
}

// ✅ If complex: Separate data sources
class TodoRepositoryImpl {
  final RemoteTodoDataSource remote;
  final LocalTodoDataSource local;
  
  Future<List<Todo>> getTodos() async {
    try {
      final todos = await remote.getTodos();
      await local.cacheTodos(todos);
      return todos;
    } catch (e) {
      return local.getTodos(); // Fallback to cache
    }
  }
}
```

### ✅ Controllers / State
- Only manage state and call use cases
- Never call APIs directly
- Handle loading and error states

### ✅ UI / Presentation
- Reads from state and displays data
- No business logic
- No async calls (controllers handle that)

## 🔄 Data Flow

```
User Action (UI)
    ↓
Controller (Application)
    ↓
Use Case (Domain)
    ↓
Repository Interface (Domain)
    ↓
Repository Implementation (Data)
    ↓
Data Source (Remote/Local)
    ↓
Back to Controller (via async)
    ↓
Update State
    ↓
UI Rebuilds
```

## 📦 Dependencies Used

- **flutter_riverpod**: State management and dependency injection
- **shared_preferences**: Local storage (can be replaced with any storage)
- **freezed** (optional): Immutable classes with code generation

## 🧪 Testing Strategy

### Unit Tests
- **Domain Layer**: Test use cases with mocked repositories
- **Data Layer**: Test repository implementations with mocked data sources
- **Application Layer**: Test controllers with mocked use cases

### Widget Tests
- **Presentation Layer**: Test UI widgets with mock state

## 💡 When to Skip Layers

### Skip Repository Interface If:
- Simple feature with one data source
- Not planning to swap data sources
- Team prefers less abstraction

### Skip Application Layer If:
- Very simple state (just a list)
- Using simple StatefulWidget is enough
- No need for complex state management

### Skip Data Sources If:
- Only one data source
- No caching needed
- Repository can directly call API

## 🎯 TL;DR

1. **Presentation**: Pure UI, reads state, calls controllers
2. **Application**: Manages state, calls use cases
3. **Domain**: Pure business logic, no Flutter/API deps
4. **Data**: Fetches/stores data, maps to domain entities

**Apply pragmatically based on feature complexity!**

---

This structure keeps your code **clean, testable, and maintainable** without unnecessary boilerplate.

