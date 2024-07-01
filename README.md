# gutendex_elibrary
This is a project challenge for a position in Palm Code
This Flutter application serves as an ebook reader, leveraging the Gutenberg Project's API to fetch and display books. The app includes features like book listing, searching, book details, and the ability to like and save books. The app also caches book data and images for offline use and employs the BLoC pattern for state management.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Running the App](#running-the-app)
- [Dependencies](#dependencies)
- [Project Structure](#project-structure)
- [Testing](#testing)
- [API](#api)
- [Screenshots](#screenshots)
- [Contributing](#contributing)
- [License](#license)

## Features

- Book listing with infinite scrolling
- Search books by author or keyword
- Book detail page with recommendations
- Like and save books to SQLite
- Caching of books and images for offline use
- BLoC pattern for state management
- Responsive design for various screen sizes

## Installation

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (version 2.5.0 or later)
- [Dart](https://dart.dev/get-dart) (version 2.14.0 or later)

### Clone the Repository

```bash
git clone https://github.com/yourusername/flutter-ebook-reader.git
cd flutter-ebook-reader
```

### Install Dependencies
```bash
flutter pub get
```

### Hive Setup
Ensure you have Hive installed and set up:
```bash
flutter packages pub run build_runner build
```

### API Configuration
If you need to configure the API endpoint, update the ApiService class in lib/api_service.dart.

#### Running the App

##### For Android
```bash
flutter run
```

##### For iOS
```bash
Copy code
flutter run
```

##### For Web
```bash
Copy code
flutter run -d chrome
```

## Dependencies
The project uses several Flutter packages:

- flutter_bloc: State management
- equatable: Simplifies equality comparisons
- http: HTTP requests
- hive: Lightweight and fast key-value database
- hive_flutter: Extensions for Flutter
- path_provider: Accessing common storage locations
- cached_network_image: Caching images
- lottie: Animation library for Flutter
- bloc_test: Utilities for testing BLoC
- mocktail: Mocking library for Dart
- hive_test: Testing Hive


## Project Structure
```bash
lib/
├── api_service.dart          # API service for fetching books
├── blocs/                    # BLoC and Cubit implementations
│   ├── book_cubit.dart       # Cubit for managing book states
│   ├── book_state.dart       # States for BookCubit
├── models/                   # Data models
│   ├── book.dart             # Book model
│   ├── api_response.dart     # API response model
├── repositories/             # Data repositories
│   ├── book_repository.dart  # Repository for book data
├── screens/                  # UI screens
│   ├── book_detail.dart      # Book detail screen
│   ├── book_list.dart        # Book listing screen
│   ├── search_page.dart      # Search screen
├── widgets/                  # Reusable widgets
│   ├── book_card.dart        # Widget for displaying a book card
│   ├── recommended_books.dart# Widget for displaying recommended books
├── main.dart                 # Main entry point
```

## Testing
To run the tests, use the following command:

```bash
flutter test
```

### Testing the BookCubit
The project includes unit tests for the BookCubit and its states. The tests are located in the test/ directory.

## API
The app uses the Gutenberg Project's API to fetch book data. You can explore the API documentation here.

Contributing
If you'd like to contribute, please fork the repository and use a feature branch. Pull requests are warmly welcome.

Fork the repository.
Create your feature branch (git checkout -b feature/AmazingFeature).
Commit your changes (git commit -m 'Add some AmazingFeature').
Push to the branch (git push origin feature/AmazingFeature).
Open a pull request.

License
This project is licensed under the MIT License - see the LICENSE file for details.
