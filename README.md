# 📱 Social Media App

A modern, feature-rich social media application built with Flutter, featuring a sleek UI, real-time interactions, and comprehensive media support.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/BLoC-3DDC84?style=for-the-badge&logo=flutter&logoColor=white)

## ✨ Features

### 🔐 Authentication
- **User Registration** with profile photo, email validation, and age verification
- **Secure Login** with modern UI and smooth animations
- **Profile Management** with gradient avatars and user initials

### 📝 Posts & Content
- **Rich Post Creation** with title, body, and multiple media attachments
- **Media Support** for images and videos with custom video player
- **Interactive Feed** with like/unlike functionality and comment system
- **Nested Comments** with reply functionality and real-time updates

### 🎬 Media Experience
- **Advanced Video Player** with custom controls, seek functionality, and double-tap to skip
- **Media Carousel** with smooth transitions, loading states, and fullscreen preview
- **Gallery Picker** with single/multi-select modes, album browsing, and performance optimization
- **Media Viewer** with immersive fullscreen experience and gesture controls

### 🎨 User Interface
- **Modern Material 3 Design** with custom theming and gradient elements
- **Smooth Animations** throughout the app with haptic feedback
- **Dark/Light Theme** support with consistent color schemes
- **Responsive Design** optimized for different screen sizes

### 🚀 Performance & Quality
- **Optimized State Management** using BLoC pattern
- **Local Data Persistence** with Hive database
- **Memory Management** with proper widget disposal and caching
- **Error Handling** with beautiful error states and user feedback

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.x |
| **Language** | Dart |
| **State Management** | BLoC|
| **Local Storage** | Hive |
| **Navigation** | Go Router |
| **Media Handling** | Video Player, Photo Manager |
| **UI Components** | Carousel Slider, Custom Widgets |

## 📦 Dependencies

```yaml
dependencies:
  # Core Flutter
  flutter:
    sdk: flutter

  # State Management
  bloc: ^*
  flutter_bloc: ^*
  
  # Local Storage
  hive: ^*
  hive_flutter: ^*
  
  # Navigation
  go_router: ^*
  
  # Media & File Handling
  video_player: ^*
  photo_manager: ^*
  file_picker: ^*
  carousel_slider: ^*
  
  # Utilities
  nb_utils: ^*
  get_it: ^*
  path_provider: ^*
  crypto: ^*
  uuid: ^*
  
  # Code Generation
  freezed_annotation: ^*
  
  # Development
  flutter_launcher_icons: ^*
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/mitesh-chandra/social_media_app.git
   cd social_media_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate required files**
   ```bash
   dart run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
📦lib
 ┣ 📂common_ui
 ┃ ┗ 📜error_screen.dart
 ┣ 📂core
 ┃ ┣ 📂route
 ┃ ┃ ┗ 📜app_route.dart
 ┃ ┣ 📂Theme
 ┃ ┃ ┗ 📜app_theme.dart
 ┃ ┣ 📜app_constant.dart
 ┃ ┗ 📜dependency_injection.dart
 ┣ 📂data
 ┃ ┣ 📂db
 ┃ ┃ ┗ 📜db.dart
 ┃ ┗ 📂hive
 ┃ ┃ ┗ 📜hive_service.dart
 ┣ 📂modules
 ┃ ┣ 📂auth
 ┃ ┃ ┣ 📂bloc
 ┃ ┃ ┃ ┣ 📜auth_bloc.dart
 ┃ ┃ ┃ ┣ 📜auth_bloc.freezed.dart
 ┃ ┃ ┃ ┣ 📜auth_event.dart
 ┃ ┃ ┃ ┣ 📜auth_state.dart
 ┃ ┃ ┃ ┗ 📜auth_store.dart
 ┃ ┃ ┗ 📂ui
 ┃ ┃ ┃ ┣ 📜login_screen.dart
 ┃ ┃ ┃ ┗ 📜sign_up_screen.dart
 ┃ ┣ 📂custom_gallery
 ┃ ┃ ┗ 📂ui
 ┃ ┃ ┃ ┗ 📜gallery_screen.dart
 ┃ ┣ 📂main_feed
 ┃ ┃ ┗ 📂ui
 ┃ ┃ ┃ ┗ 📜main_feed_screen.dart
 ┃ ┣ 📂post
 ┃ ┃ ┣ 📂bloc
 ┃ ┃ ┃ ┣ 📜post_bloc.dart
 ┃ ┃ ┃ ┣ 📜post_bloc.freezed.dart
 ┃ ┃ ┃ ┣ 📜post_event.dart
 ┃ ┃ ┃ ┣ 📜post_state.dart
 ┃ ┃ ┃ ┗ 📜post_store.dart
 ┃ ┃ ┣ 📂db
 ┃ ┃ ┃ ┗ 📜post_db.dart
 ┃ ┃ ┣ 📂model
 ┃ ┃ ┃ ┣ 📜comment_model.dart
 ┃ ┃ ┃ ┣ 📜like_model.dart
 ┃ ┃ ┃ ┣ 📜media_model.dart
 ┃ ┃ ┃ ┣ 📜post_model.dart
 ┃ ┃ ┃ ┗ 📜post_model.g.dart
 ┃ ┃ ┗ 📂ui
 ┃ ┃ ┃ ┣ 📜create_post_screen.dart
 ┃ ┃ ┃ ┣ 📜nested_comment_widget.dart
 ┃ ┃ ┃ ┣ 📜post_card.dart
 ┃ ┃ ┃ ┗ 📜post_detail_page.dart
 ┃ ┗ 📂user
 ┃ ┃ ┣ 📂db
 ┃ ┃ ┃ ┗ 📜user_db.dart
 ┃ ┃ ┗ 📂model
 ┃ ┃ ┃ ┣ 📜user_model.dart
 ┃ ┃ ┃ ┗ 📜user_model.g.dart
 ┣ 📂utils
 ┃ ┣ 📜app_bloc_observer.dart
 ┃ ┣ 📜custom_loader.dart
 ┃ ┣ 📜custom_video_player.dart
 ┃ ┣ 📜global_functions.dart
 ┃ ┣ 📜hash_password.dart
 ┃ ┣ 📜media_carousel.dart
 ┃ ┣ 📜media_preview.dart
 ┃ ┗ 📜message_dialog.dart
 ┗ 📜main.dart
```

## 🎯 Key Features Breakdown

### Authentication System
- Modern signup/login screens with animations
- Form validation and error handling
- Profile image selection from gallery
- Age verification (13+ requirement)

### Post Management
- Create posts with rich content
- Add multiple images and videos
- Edit and delete own posts
- Real-time like/unlike functionality

### Comment System
- Add comments to posts
- Reply to existing comments
- Nested comment display
- Real-time comment updates

### Media Handling
- Custom video player with advanced controls
- Image and video carousel with indicators
- Gallery picker with album browsing
- Fullscreen media viewer with gestures

### UI/UX Excellence
- Consistent Material 3 theming
- Smooth page transitions
- Loading states and error handling
- Haptic feedback for interactions

## 🔧 Configuration

### Theme Customization
The app uses a centralized theme system in `lib/utils/app_theme.dart`:
- Primary colors and gradients
- Typography scale and weights
- Component-specific styling
- Dark/light mode support

### Navigation Setup
Routes are defined in `lib/core/route/app_route.dart` using Go Router:
- Named routes for all screens
- Parameter passing for dynamic content
- Navigation guards for authentication

## 📱 Screenshots

| Feature | Screenshot |
|---------|------------|
| Login Screen | *Modern authentication UI* |
| Feed Screen | *Post carousel with interactions* |
| Create Post | *Media attachment and rich content* |
| Video Player | *Custom controls and seeking* |
| Gallery Picker | *Multi-select with albums* |

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- BLoC library for state management
- Community packages for media handling
- Material Design for UI guidelines

---

Made with ❤️ by Mitesh (https://github.com/mitesh-chandra)