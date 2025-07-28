# 📱 Flutter CV Portfolio App

A modern, responsive CV/Portfolio application built with Flutter that showcases personal information, skills, experiences, and projects. Features real-time data management with Firebase and PDF resume generation.

## ✨ Features

- 📋 **Personal Profile Management** - Display and edit personal information
- 🏢 **Experience Tracking** - Manage work experiences and career timeline
- 🚀 **Project Showcase** - Display portfolio projects with details
- 🛠️ **Skills Management** - Organize technical and soft skills
- 📞 **Contact Information** - Interactive contact details with social media links
- 📄 **Resume Generator** - Generate PDF resumes from profile data
- 🔥 **Firebase Integration** - Real-time database for data persistence
- 🎨 **Custom Themes** - Gradient themes and modern UI design
- 📱 **Responsive Design** - Works on various screen sizes
- 🔄 **State Management** - Provider pattern for efficient state management

## 🏗️ Architecture

### Project Structure

```
lib/
├── main.dart                    # App entry point
├── firebase_options.dart        # Firebase configuration
│
├── core/                        # Core functionality
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_constants.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── gradient_theme_extension.dart
│   └── utils/
│       ├── validators.dart
│       └── extensions.dart
│
├── model/                       # Data models
│   ├── contact_model.dart
│   ├── experience_model.dart
│   ├── project_model.dart
│   ├── skill_model.dart
│   └── social_media_model.dart
│
├── services/                    # Business logic services
│   ├── firebase_service.dart
│   ├── storage_service.dart
│   └── pdf_service.dart
│
├── pages/                       # UI screens with modular structure
│   ├── contact/
│   │   ├── contact_page.dart
│   │   ├── contact_provider.dart
│   │   └── widgets/
│   │       ├── contact_card.dart
│   │       ├── info_tile.dart
│   │       └── social_media_row.dart
│   ├── profile/
│   │   ├── profile_page.dart
│   │   ├── profile_provider.dart
│   │   └── widgets/
│   ├── experience/
│   │   ├── experience_page.dart
│   │   ├── experience_provider.dart
│   │   └── widgets/
│   ├── projects/
│   │   ├── projects_page.dart
│   │   ├── project_provider.dart
│   │   └── widgets/
│   ├── skills/
│   │   ├── skills_page.dart
│   │   ├── skills_provider.dart
│   │   └── widgets/
│   ├── generator/
│   │   ├── resume_generator_page.dart
│   │   ├── resume_generator_provider.dart
│   │   └── widgets/
│   └── views/
│       └── home_page.dart
│
├── widgets/                     # Shared widgets
│   ├── custom_app_bar.dart
│   ├── custom_button.dart
│   ├── loading_widget.dart
│   └── errors_widget.dart
│
└── firebase/                    # Firebase configuration
    └── firebase_init.dart
```

### Architecture Principles

- **🏛️ Modular Architecture**: Each page is self-contained with its own provider and widgets
- **🔄 Provider Pattern**: State management using Provider package
- **📊 Model-Driven**: Type-safe data models for all entities
- **🔥 Firebase Integration**: Real-time database with offline support
- **🎨 Theme System**: Extensible theming with gradient support
- **📱 Responsive Design**: Adaptive UI for different screen sizes

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Firebase project setup
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flutter_cv_portfolio.git
   cd flutter_cv_portfolio
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Realtime Database
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories
   - Run Firebase configuration:
     ```bash
     flutterfire configure
     ```

4. **Database Structure**
   Set up your Firebase Realtime Database with this structure:
   ```json
   {
     "Portfolio": {
       "about_us": {
         "name": "Your Name",
         "designation": "Your Title",
         "email": "your.email@example.com",
         "phone": "+1234567890",
         "location": "Your City, Country",
         "bio": "Your bio description",
         "profileImage": "https://your-image-url.com",
         "socialMedia": {
           "linkedin": "https://linkedin.com/in/yourprofile",
           "github": "https://github.com/yourusername",
           "medium": "https://medium.com/@yourusername"
         }
       },
       "experience": {
         "exp1": {
           "company": "Company Name",
           "position": "Your Position",
           "startDate": "2020-01-01",
           "endDate": "2023-12-31",
           "description": "Job description"
         }
       },
       "portfolio": {
         "project1": {
           "title": "Project Title",
           "description": "Project description",
           "technologies": ["Flutter", "Firebase"],
           "githubUrl": "https://github.com/yourrepo",
           "liveUrl": "https://your-project.com"
         }
       },
       "skills": {
         "skill1": {
           "name": "Flutter",
           "level": 90,
           "category": "Mobile Development"
         }
       }
     }
   }
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1              # State management
  firebase_core: ^2.24.2        # Firebase core
  firebase_database: ^10.4.0    # Realtime database
  
  # UI & Theming
  cupertino_icons: ^1.0.6
  font_awesome_flutter: ^10.6.0
  
  # Networking & Utils
  url_launcher: ^6.2.2          # Launch URLs
  qr_flutter: ^4.1.0            # QR code generation
  pdf: ^3.10.7                  # PDF generation
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
```

## 🎨 Key Components

### 1. State Management with Provider

Each page has its own provider for isolated state management:

```dart
// Example: ContactProvider
class ContactProvider extends ChangeNotifier {
  ContactModel? _contactInfo;
  bool _isLoading = false;
  String? _error;

  // Getters
  ContactModel? get contactInfo => _contactInfo;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Methods
  Future<void> loadContactInfo() async {
    // Load data from Firebase
  }
}
```

### 2. Firebase Service Layer

Centralized service for Firebase operations:

```dart
class FirebaseService {
  Future<Map<String, dynamic>?> getAboutInfo() async {
    // Firebase operations
  }
  
  Future<void> updateAboutInfo(Map<String, dynamic> data) async {
    // Update operations
  }
}
```

### 3. Type-Safe Models

Structured data models with JSON serialization:

```dart
class ContactModel {
  final String? name;
  final String? email;
  final SocialMediaModel? socialMedia;
  
  ContactModel({this.name, this.email, this.socialMedia});
  
  factory ContactModel.fromMap(Map<String, dynamic> map) {
    // JSON to model conversion
  }
}
```

## 🔧 Configuration

### Firebase Rules
Set up security rules for your Realtime Database:

```json
{
  "rules": {
    "Portfolio": {
      ".read": true,
      ".write": "auth != null"
    }
  }
}
```

### Theme Configuration
Customize themes in `core/theme/app_theme.dart`:

```dart
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    // Your theme configuration
  ).copyWith(
    extensions: [
      GradientTheme(
        backgroundGradient: LinearGradient(
          // Your gradient configuration
        ),
      ),
    ],
  );
}
```

## 📱 Features Overview

### 🏠 Home/Profile Page
- Personal information display
- Profile image with fallback
- Bio and contact details
- Quick navigation to other sections

### 💼 Experience Page
- Timeline view of work experiences
- Add/Edit/Delete functionality
- Company and position details
- Date range management

### 🚀 Projects Page
- Grid/List view of portfolio projects
- Project details with screenshots
- Technology tags
- GitHub and live demo links

### 🛠️ Skills Page
- Categorized skill display
- Progress bars for skill levels
- Add/Remove skills functionality
- Skill level management

### 📞 Contact Page
- Interactive contact information
- Clickable email and phone links
- Social media integration
- QR code for CV download

### 📄 Resume Generator
- PDF generation from profile data
- Multiple template options
- Export and share functionality
- Print-ready format

## 🔒 Security

- Firebase security rules implementation
- Input validation for all forms
- Error handling and user feedback
- Secure URL launching

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

## 📈 Performance

- Optimized Firebase queries
- Image caching and optimization
- Lazy loading for large lists
- Efficient state management




## 🎯 Roadmap

- [ ] Dark/Light theme toggle
- [ ] Multi-language support
- [ ] Offline mode with local storage
- [ ] Analytics integration
- [ ] Push notifications
- [ ] Admin panel for content management
- [ ] Export to different formats (Word, HTML)
- [ ] Advanced PDF templates
- [ ] Portfolio statistics
- [ ] Blog integration
