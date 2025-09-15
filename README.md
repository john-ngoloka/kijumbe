# Kijumbe - Flutter Clean Architecture App

A Flutter application built with clean architecture principles, featuring authentication with phone and password login.

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles with the following layers:

### **Project Structure**
```
lib/
├── core/                           # Shared utilities and configurations
│   ├── constants/                  # App constants and configuration
│   ├── database/                   # Database setup (Isar)
│   ├── di/                         # Dependency injection setup
│   ├── errors/                     # Error handling (failures & exceptions)
│   ├── network/                    # Network configuration (Dio)
│   └── utils/                      # Utility functions and validators
├── features/
│   └── authentication/            # Authentication feature module
│       ├── data/                   # Data layer
│       │   ├── datasources/        # Remote & local data sources
│       │   ├── models/             # Data models (DTOs)
│       │   └── repositories/       # Repository implementations
│       ├── domain/                 # Domain layer
│       │   ├── entities/           # Business entities
│       │   ├── repositories/       # Repository interfaces
│       │   └── usecases/           # Business logic use cases
│       └── presentation/           # Presentation layer
│           ├── cubit/              # State management (Cubit)
│           ├── pages/              # UI pages/screens
│           └── widgets/            # Reusable UI components
└── main.dart                       # App entry point
```

## 🛠️ Tech Stack

### **State Management**
- **Flutter Bloc** - For state management using Cubit pattern
- **Equatable** - For value equality in states

### **Dependency Injection**
- **GetIt** - Service locator for dependency injection
- **Injectable** - Code generation for dependency injection

### **Local Storage**
- **SharedPreferences** - For simple key-value storage (tokens, preferences)
- **Isar** - For local database operations

### **Network**
- **Dio** - HTTP client for API calls
- **Dartz** - Functional programming (Either type for error handling)

### **Code Generation**
- **Freezed** - Immutable classes and unions
- **Json Annotation** - JSON serialization
- **Build Runner** - Code generation runner

## 🚀 Features

### **Authentication**
- ✅ Phone number and password login
- ✅ Token-based authentication
- ✅ Automatic token refresh
- ✅ Persistent login state
- ✅ Secure logout with token cleanup

### **Architecture Benefits**
- ✅ **Separation of Concerns** - Each layer has specific responsibilities
- ✅ **Testability** - Easy to unit test each layer independently
- ✅ **Maintainability** - Changes in one layer don't affect others
- ✅ **Scalability** - Easy to add new features following the same pattern
- ✅ **Dependency Inversion** - High-level modules don't depend on low-level modules

## 📱 Screens

### **Login Screen**
- Phone number input with validation
- Password input with show/hide toggle
- Loading states and error handling
- Form validation

### **Home Screen**
- User profile display
- Account information
- Logout functionality
- Navigation to other features

## 🔧 Setup Instructions

### **1. Install Dependencies**
```bash
flutter pub get
```

### **2. Generate Code**
```bash
flutter packages pub run build_runner build
```

### **3. Run the App**
```bash
flutter run
```

## 🏛️ Architecture Layers

### **1. Presentation Layer**
- **Cubit**: Manages authentication state
- **Pages**: Login and Home screens
- **Widgets**: Reusable UI components

### **2. Domain Layer**
- **Entities**: User and AuthTokens business objects
- **Use Cases**: Login, Logout, GetCurrentUser, IsLoggedIn
- **Repository Interfaces**: Contracts for data access

### **3. Data Layer**
- **Remote Data Source**: API calls for authentication
- **Local Data Source**: SharedPreferences and Isar database
- **Repository Implementation**: Coordinates between data sources
- **Models**: Data transfer objects with JSON serialization

## 🔐 Authentication Flow

1. **User enters credentials** → Login form validation
2. **AuthCubit calls LoginUseCase** → Business logic execution
3. **LoginUseCase calls AuthRepository** → Data layer coordination
4. **AuthRepository makes API call** → Remote authentication
5. **Success response** → Save tokens locally, navigate to home
6. **Error response** → Show error message to user

## 🧪 Testing Strategy

The clean architecture enables easy testing:

- **Unit Tests**: Test use cases, repositories, and data sources independently
- **Widget Tests**: Test UI components in isolation
- **Integration Tests**: Test complete user flows

## 📦 Dependencies

### **Production Dependencies**
```yaml
dependencies:
  flutter_bloc: ^8.1.3          # State management
  get_it: ^7.6.4                # Dependency injection
  shared_preferences: ^2.2.2    # Local storage
  isar: ^3.1.0+1               # Local database
  dio: ^5.4.0                  # HTTP client
  equatable: ^2.0.5            # Value equality
  dartz: ^0.10.1               # Functional programming
```

### **Development Dependencies**
```yaml
dev_dependencies:
  build_runner: ^2.4.7         # Code generation
  injectable_generator: ^2.4.1 # DI code generation
  freezed: ^2.4.6              # Immutable classes
  json_serializable: ^6.7.1    # JSON serialization
  isar_generator: ^3.1.0+1     # Isar code generation
```

## 🔄 Data Flow

```
UI (Login Form) 
    ↓
AuthCubit (State Management)
    ↓
LoginUseCase (Business Logic)
    ↓
AuthRepository (Data Coordination)
    ↓
AuthRemoteDataSource (API Call)
    ↓
AuthLocalDataSource (Local Storage)
```

## 🎯 Next Steps

1. **Add more features** following the same architecture pattern
2. **Implement unit tests** for each layer
3. **Add error handling** for network failures
4. **Implement offline support** using Isar database
5. **Add user registration** and password reset flows

## 📝 Notes

- The app uses phone number and password for authentication
- Tokens are automatically refreshed when expired
- User data is cached locally for offline access
- All dependencies are injected using GetIt service locator
- Code generation is used for models, dependency injection, and JSON serialization

## 🤝 Contributing

When adding new features, follow the established architecture:

1. Create entities in the domain layer
2. Define repository interfaces
3. Implement use cases
4. Create data models and sources
5. Implement repository
6. Create Cubit for state management
7. Build UI components
8. Register dependencies in GetIt

This ensures consistency and maintainability across the entire application.