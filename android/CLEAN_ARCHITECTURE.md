# Clean Architecture Android App - 2025 Blueprint

This project implements a **Clean Architecture** structure for Android development using modern technologies: **Jetpack Compose**, **Kotlin Coroutines**, and **Hilt** for dependency injection.

> **Note:** This is a **Flutter project**, and Android native code correctly resides in the `android/` folder. The `lib/` folder is reserved for Dart/Flutter code only.

## 📁 Project Structure

```
poultry_core/
├── lib/                           # Flutter/Dart code (Flutter UI)
│   └── main.dart
│
└── android/
    └── app/src/main/java/com/example/poultry_core/
├── data/                          # Data Layer
│   ├── datasource/
│   │   └── local/
│   │       ├── TodoEntity.kt      # Room entity
│   │       ├── TodoDao.kt         # Room DAO
│   │       ├── TodoDatabase.kt    # Room database
│   │       └── LocalTodoDataSource.kt  # Local data source
│   └── repository/
│       └── TodoRepositoryImpl.kt  # Repository implementation
│
├── domain/                        # Domain Layer (Business Logic)
│   ├── model/
│   │   └── Todo.kt                # Domain model
│   ├── usecase/                   # Use cases (business logic)
│   │   ├── GetTodosUseCase.kt
│   │   ├── AddTodoUseCase.kt
│   │   ├── ToggleTodoUseCase.kt
│   │   └── DeleteTodoUseCase.kt
│   └── repository/
│       └── TodoRepository.kt      # Repository interface
│
├── presentation/                  # Presentation Layer (UI)
│   ├── ui/
│   │   └── TodoScreen.kt          # Jetpack Compose UI
│   └── viewmodel/
│       └── TodoViewModel.kt       # ViewModel with UI state
│
├── di/                            # Dependency Injection
│   ├── DatabaseModule.kt          # Database dependencies
│   ├── RepositoryModule.kt        # Repository bindings
│   └── UseCaseModule.kt           # Use case providers
│
├── PoultryCoreApplication.kt      # Application class with Hilt
└── NativeTodoActivity.kt          # Native Android Activity (optional, can be launched from Flutter)

Note: The Flutter MainActivity is in: android/app/src/main/kotlin/com/example/poultry_core/MainActivity.kt
```

## 🏗️ The Three Core Layers

### 1. **Domain Layer** (Business Logic)
- **Pure Kotlin** - No Android dependencies
- **Models**: Business entities (e.g., `Todo`)
- **Use Cases**: Encapsulate business logic (e.g., `GetTodosUseCase`, `AddTodoUseCase`)
- **Repository Interface**: Contract for data operations

**Key Benefits:**
- ✅ Testable without Android framework
- ✅ Reusable across platforms
- ✅ Independent of data sources

### 2. **Data Layer** (Data Management)
- **Repository Implementation**: Coordinates data sources
- **Data Sources**: 
  - Local (Room database)
  - Remote (can add API calls later)
- **Entity Mapping**: Converts between domain models and data models

**Key Benefits:**
- ✅ Single source of truth
- ✅ Easy to add/swap data sources
- ✅ Centralized error handling

### 3. **Presentation Layer** (UI)
- **Jetpack Compose**: Modern declarative UI
- **ViewModel**: Manages UI state and business logic
- **UI State**: Immutable data classes representing screen state

**Key Benefits:**
- ✅ Separation of concerns
- ✅ Testable ViewModels
- ✅ Reusable UI components

## 🔄 Data Flow

```
User Action (UI)
    ↓
ViewModel (Presentation)
    ↓
Use Case (Domain)
    ↓
Repository (Domain Interface)
    ↓
Repository Implementation (Data)
    ↓
Data Source (Local/Remote)
    ↓
Back to ViewModel (via Flow)
    ↓
UI Update
```

## 🛠️ Technologies Used

- **Jetpack Compose**: Modern UI toolkit
- **Hilt**: Dependency injection framework
- **Room**: Local database persistence
- **Kotlin Coroutines**: Asynchronous programming
- **Flow**: Reactive data streams
- **Material Design 3**: UI components

## 📦 Dependencies

Key dependencies added to `build.gradle.kts`:

- `androidx.compose.ui:ui` - Compose UI
- `androidx.compose.material3:material3` - Material Design 3
- `com.google.dagger:hilt-android` - Hilt DI
- `androidx.room:room-ktx` - Room database
- `org.jetbrains.kotlinx:kotlinx-coroutines-android` - Coroutines

## 🎯 Clean Architecture Principles

### Dependency Rule
- **Inner layers don't know about outer layers**
- Domain layer has no dependencies on data or presentation
- Data layer depends on domain (implements domain interfaces)
- Presentation depends on domain (uses use cases)

### Single Responsibility
- Each class has one reason to change
- Use cases encapsulate single business operations
- ViewModels handle UI logic only

### Testability
- Domain layer is fully testable without Android
- Use cases are pure functions
- ViewModels can be tested with mocked use cases

## 🚀 Usage Example

### Adding a New Feature

1. **Domain Layer**: Create model, use case, and repository interface
```kotlin
// domain/model/NewFeature.kt
data class NewFeature(...)

// domain/usecase/GetNewFeatureUseCase.kt
class GetNewFeatureUseCase(private val repository: NewFeatureRepository) {
    operator fun invoke(): Flow<List<NewFeature>> = repository.getFeatures()
}
```

2. **Data Layer**: Implement repository and data sources
```kotlin
// data/repository/NewFeatureRepositoryImpl.kt
class NewFeatureRepositoryImpl @Inject constructor(
    private val dataSource: NewFeatureDataSource
) : NewFeatureRepository {
    override fun getFeatures(): Flow<List<NewFeature>> {
        return dataSource.getFeatures()
    }
}
```

3. **Presentation Layer**: Create ViewModel and UI
```kotlin
// presentation/viewmodel/NewFeatureViewModel.kt
@HiltViewModel
class NewFeatureViewModel @Inject constructor(
    private val getNewFeatureUseCase: GetNewFeatureUseCase
) : ViewModel() {
    // UI state management
}

// presentation/ui/NewFeatureScreen.kt
@Composable
fun NewFeatureScreen(viewModel: NewFeatureViewModel = hiltViewModel()) {
    // Compose UI
}
```

4. **DI Layer**: Provide dependencies in Hilt modules

## 📝 Key Files

- **PoultryCoreApplication.kt**: Application class with `@HiltAndroidApp`
- **NativeTodoActivity.kt**: Native Android Activity with Compose UI (can be launched from Flutter)
- **MainActivity.kt** (in kotlin folder): Flutter Activity - main entry point
- **TodoViewModel.kt**: Manages UI state using use cases
- **TodoRepository.kt**: Interface defining data operations
- **TodoRepositoryImpl.kt**: Implementation coordinating data sources

## 🔄 Flutter Integration

This Clean Architecture code is in the `android/` folder, which is the **correct location** for Android native code in Flutter projects:

- ✅ **`lib/`** → For Dart/Flutter code only
- ✅ **`android/app/src/main/java/`** → For Android native Kotlin/Java code
- ✅ **`android/app/src/main/kotlin/`** → Also for Android native code

To use the native Android features from Flutter, you can:
1. Launch `NativeTodoActivity` from Flutter using platform channels
2. Create Flutter platform channels to call the repository/use cases directly
3. Use the native code as a standalone Android module

## 🧪 Testing

The architecture is designed for easy testing:

- **Domain Layer**: Unit tests with pure Kotlin
- **Data Layer**: Unit tests with mocked data sources
- **Presentation Layer**: ViewModel tests with mocked use cases
- **UI Layer**: Compose UI tests

## 🔧 Next Steps

- Add remote data source (Retrofit)
- Implement offline-first architecture
- Add caching strategies
- Add unit tests
- Add UI tests
- Implement error handling strategies

---

Built with ❤️ using Clean Architecture principles for scalable, testable, and maintainable Android apps.

