# 🍳 PantryChef – AI-Powered Recipe Generator

> **Turn your ingredients into delicious recipes** using the power of Groq AI.

PantryChef is a production-quality Flutter Android application that helps you decide what to cook based on the ingredients you already have at home. Simply enter your available ingredients, set your meal preferences, and let the AI chef generate personalised recipe suggestions in seconds.

---

## ✨ Features

| Feature | Description |
|---|---|
| 🤖 **AI Recipe Generation** | Powered by Groq's `llama-3.3-70b-versatile` model for fast, high-quality recipes |
| 🥘 **Ingredient Input** | Type ingredients manually or add them one by one with chips |
| 🎯 **Smart Filtering** | Filter by meal type, dietary preference and cooking time |
| 📋 **Recipe Details** | Full instructions with numbered steps and ingredient breakdown |
| ❤️ **Favourites** | Save recipes locally with persistent storage (survives app restarts) |
| 📴 **Offline Demo Mode** | Demo recipes shown when no API key is configured |
| 🎨 **Modern UI** | Warm food-inspired design with animations and gradient cards |

---

## 🏗️ Technology Stack

- **Framework**: Flutter 3.x
- **Language**: Dart 3.x
- **AI**: [Groq API](https://console.groq.com) — `llama-3.3-70b-versatile` model
- **HTTP Client**: `http ^1.2.1`
- **Local Storage**: `shared_preferences ^2.2.3`
- **Image Caching**: `cached_network_image ^3.3.1`
- **Fonts**: Google Fonts (Poppins) via `google_fonts ^6.2.1`
- **Platform**: Android (minSdk 21 / Android 5.0+)

---

## 📁 Project Structure

```
pantrychef/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   └── recipe.dart              # Recipe & MealPreferences data models
│   ├── screens/
│   │   ├── splash_screen.dart       # Animated splash screen
│   │   ├── main_navigation_screen.dart  # Bottom nav shell
│   │   ├── home_screen.dart         # Ingredient input & preferences
│   │   ├── recipe_results_screen.dart   # AI-generated recipe cards
│   │   ├── recipe_detail_screen.dart    # Full recipe view + save
│   │   └── favourites_screen.dart   # Saved recipes list
│   ├── services/
│   │   └── groq_service.dart        # Groq API integration
│   ├── storage/
│   │   └── favourites_storage.dart  # SharedPreferences persistence
│   ├── widgets/
│   │   ├── ingredient_chip.dart     # Removable ingredient chip
│   │   ├── preference_selector.dart # Horizontal option selector
│   │   └── recipe_card.dart         # Recipe card with image
│   └── utils/
│       ├── app_theme.dart           # Design system & colours
│       ├── app_constants.dart       # API config & constant values
│       ├── api_config.dart          # Secure API key loading
│       └── demo_recipes.dart        # Fallback demo data
├── assets/
│   └── config/
│       └── api_key.txt              # ⚠️ NOT committed to git – create manually
├── android/
│   ├── app/
│   │   ├── build.gradle
│   │   ├── proguard-rules.pro
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       ├── kotlin/com/pantrychef/pantrychef/
│   │       │   └── MainActivity.kt
│   │       └── res/
│   │           ├── drawable/launch_background.xml
│   │           └── values/styles.xml
│   ├── build.gradle
│   ├── settings.gradle
│   └── gradle.properties
├── pubspec.yaml
├── .gitignore
└── README.md
```

---

## 🚀 Setup Instructions

### Prerequisites

Ensure you have the following installed:

1. **Flutter SDK** (3.0.0 or higher) – [Install Flutter](https://docs.flutter.dev/get-started/install)
2. **Android Studio** or **VS Code** with Flutter extension
3. **Android SDK** (API level 21+)
4. **Java 11+**
5. **Git**

Verify your setup:
```bash
flutter doctor
```

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/pantrychef.git
cd pantrychef
```

### 2. Install Dependencies

```bash
flutter pub get
```

---

## 🔑 Groq API Key Setup

> **Security**: The API key is never hardcoded in source code. It is loaded at runtime from a local file that is excluded from version control via `.gitignore`.

### Step 1: Get Your Groq API Key

1. Visit [https://console.groq.com](https://console.groq.com)
2. Create a free account
3. Navigate to **API Keys**
4. Click **Create API Key**
5. Copy the generated key (starts with `gsk_...`)

### Option A: Using `--dart-define` (Recommended)

You can pass the API key directly when launching or building without modifying any files:

```bash
flutter run --dart-define=GROQ_API_KEY=gsk_your_actual_groq_api_key_here
```

For building release APK:
```bash
flutter build apk --release --dart-define=GROQ_API_KEY=gsk_your_actual_groq_api_key_here
```

### Option B: Using `assets/config/api_key.txt`

Alternatively, create `assets/config/api_key.txt` in the project root:

```bash
# Copy from the provided example template
cp assets/config/api_key.example.txt assets/config/api_key.txt
```

Then edit `assets/config/api_key.txt` and replace the content with your Groq API key:
```
gsk_your_actual_groq_api_key_here
```

### Step 3: Verify `.gitignore`

The `.gitignore` already includes:
```
assets/config/api_key.txt
```

**Never commit this file.** Double-check before pushing:
```bash
git status  # api_key.txt should NOT appear
```

### Without an API Key

If no API key is configured, the app will automatically show **demo recipes** so you can still explore the full UI, smooth animations, and local favourites saving. A friendly notice banner will appear on the Home screen.

---

## ▶️ Running the App

### Connect a Device

Connect an Android device via USB with Developer Mode and USB Debugging enabled, or start an Android emulator.

```bash
flutter devices  # List connected devices
```

### Run in Debug Mode

```bash
flutter run
```

### Run on Specific Device

```bash
flutter run -d DEVICE_ID
```

---

## 🧪 Testing the App

Follow this complete user flow to test all features:

1. **Open the app** – Verify the splash screen animation plays
2. **Enter ingredients** – Type `Chicken, Rice, Tomato, Onion` and tap the add button
3. **Set preferences** – Select `Dinner`, `Non-Vegetarian`, `Under 30 minutes`
4. **Generate recipes** – Tap **Generate Recipes** and wait for AI response
5. **Browse results** – View the 3 generated recipe cards
6. **Open a recipe** – Tap a card to see full ingredients and cooking steps
7. **Save to favourites** – Tap the **Save to Favourites** button (heart icon)
8. **Navigate to Favourites** – Tap the heart icon in the bottom navigation bar
9. **Verify persistence** – Close and reopen the app; your saved recipe should still be there
10. **Remove a recipe** – Swipe left on a favourite recipe to remove it

---

## 📦 Building a Release APK

### Option 1: Debug APK (for testing)

```bash
flutter build apk --debug
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Option 2: Release APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

> **Note**: For a proper Play Store release, you should configure a keystore. See [Flutter's signing guide](https://docs.flutter.dev/deployment/android#signing-the-app).

### Option 3: Split APKs by ABI (Smaller Files)

```bash
flutter build apk --split-per-abi
```

Outputs:
- `app-armeabi-v7a-release.apk` (older devices)
- `app-arm64-v8a-release.apk` (modern 64-bit devices)
- `app-x86_64-release.apk` (emulators)

### Install APK on Device

```bash
flutter install
# OR
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## 🌐 GitHub Repository Setup

```bash
# 1. Initialise git (if not already)
git init

# 2. Stage all files (the api_key.txt is already in .gitignore)
git add .

# 3. Commit the initial project
git commit -m "Initial commit: PantryChef Flutter app"

# 4. Add your GitHub remote
git remote add origin https://github.com/YOUR_USERNAME/pantrychef.git

# 5. Push to GitHub
git push -u origin main
```

**Before pushing**, verify sensitive files are excluded:
```bash
git status  # Check no api_key.txt or local.properties is listed
```

---

## 🔧 Troubleshooting

| Issue | Solution |
|---|---|
| `Flutter not found` | Ensure Flutter SDK is in your PATH |
| `No devices found` | Enable USB Debugging on Android or start an emulator |
| `API key not found` | Create `assets/config/api_key.txt` with your Groq key |
| `Groq API error 401` | Verify your API key is correct (starts with `gsk_`) |
| `Groq API error 429` | Rate limit hit – wait a moment and try again |
| `Build fails: minSdk` | Edit `android/app/build.gradle` – set `minSdk 21` |
| Images not loading | Check internet connection; placeholder is shown automatically |

---

## 🛡️ Security Notes

- **API Key**: Stored in `assets/config/api_key.txt` which is excluded from git
- **HTTPS**: All API communication uses HTTPS (enforced by Groq's endpoint)
- **Input Sanitisation**: Ingredient names are sanitised before being embedded in AI prompts
- **No Auth**: This app has no user authentication (by design – local-only data)
- **Local Storage**: Favourites stored in SharedPreferences (device-local, not synced)

> **Production Recommendation**: For a production-grade app, consider using a backend proxy server (BFF pattern) to avoid exposing the API key on the client device entirely.

---

## 📄 Licence

This project is provided for educational and personal use. See [LICENSE](LICENSE) for details.

---

*Built with Flutter 🐦 and powered by Groq AI 🤖*
