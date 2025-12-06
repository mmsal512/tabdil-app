# 💱 Tabdil - Smart Currency Converter

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

**تطبيق تحويل عملات ذكي بتصميم Hyper UI المستقبلي**

[English](#english) | [العربية](#العربية) | [Docker](#-docker-deployment)

</div>

---

## العربية

### 📝 نظرة عامة

**تبديل (Tabdil)** هو تطبيق تحويل عملات احترافي مصمم خصيصاً للسوق اليمني. يستخدم نظام أسعار هجين يجمع بين الأسعار اليدوية للريال اليمني (YER) وأسعار API للعملات الأجنبية.

### ✨ المميزات

- 🎨 **تصميم Hyper UI** - واجهة مستقبلية بتأثيرات النيون والزجاج
- 🌊 **خلفية متحركة** - أمواج Aurora ديناميكية بألوان النيون
- 🔮 **تأثير الزجاج (Glassmorphism)** - بطاقات شفافة مع تأثير ضبابي
- ✨ **أزرار تفاعلية** - تأثير ضوئي عند اللمس (Photo-reactive)
- 🧮 **واجهة آلة حاسبة** - تصميم سهل الاستخدام
- 🔄 **نظام أسعار هجين** - أسعار يدوية + أسعار API
- 📊 **عرض آخر تحديث** - تاريخ ووقت آخر تحديث للأسعار
- 👨‍💼 **لوحة تحكم المسؤول** - لتعديل الأسعار الاحتياطية
- 📦 **نظام احتياطي** - يعمل حتى بدون إنترنت
- 🏳️ **أعلام الدول** - باستخدام Unicode Emojis

### 💱 العملات المدعومة

| العملة | الرمز | العلم |
|--------|-------|-------|
| ريال يمني | YER | 🇾🇪 |
| دولار أمريكي | USD | 🇺🇸 |
| ريال سعودي | SAR | 🇸🇦 |
| درهم إماراتي | AED | 🇦🇪 |
| دينار كويتي | KWD | 🇰🇼 |
| ريال عماني | OMR | 🇴🇲 |

### 🛠️ التقنيات المستخدمة

- **Flutter** - إطار العمل
- **Dart** - لغة البرمجة
- **Supabase** - قاعدة البيانات والمصادقة
- **Provider** - إدارة الحالة
- **Open Exchange Rates API** - أسعار العملات العالمية
- **Docker** - النشر والتوزيع

### 🎨 تصميم Hyper UI

التطبيق يستخدم تصميم **"Immersive Neon Glass"** المستقبلي:

- **خلفية ديناميكية:** أمواج Aurora متحركة بألوان النيون (أزرق، بنفسجي، برتقالي)
- **بطاقات زجاجية:** تأثير Glassmorphism مع توهج ثلاثي الأبعاد
- **أزرار متفاعلة:** تأثير ضوئي ينتشر من نقطة اللمس
- **حركات سلسة:** انتقالات بـ 60fps

### 🚀 التشغيل المحلي

```bash
# استنساخ المستودع
git clone https://github.com/mmsal512/tabdil-app.git
cd tabdil-app

# تثبيت الحزم
flutter pub get

# تشغيل التطبيق (Web)
flutter run -d chrome

# تشغيل التطبيق (Mobile)
flutter run

# بناء APK
flutter build apk --release

# بناء Web
flutter build web --release
```

---

## English

### 📝 Overview

**Tabdil** is a professional currency converter app designed specifically for the Yemeni market. It uses a hybrid rate system combining manual rates for Yemeni Rial (YER) and API rates for foreign currencies.

### ✨ Features

- 🎨 **Hyper UI Design** - Futuristic interface with neon and glass effects
- 🌊 **Animated Background** - Dynamic Aurora waves with neon colors
- 🔮 **Glassmorphism** - Transparent cards with blur effect
- ✨ **Interactive Buttons** - Photo-reactive light effect on tap
- 🧮 **Calculator-style UI** - Easy-to-use interface
- 🔄 **Hybrid Rate System** - Manual rates + API rates
- 📊 **Last Update Display** - Shows last rates update time
- 👨‍💼 **Admin Panel** - For editing backup rates
- 📦 **Fallback System** - Works even without internet
- 🏳️ **Country Flags** - Using Unicode Emojis

### 🛠️ Tech Stack

- **Flutter** - Framework
- **Dart** - Programming Language
- **Supabase** - Database & Authentication
- **Provider** - State Management
- **Open Exchange Rates API** - Currency rates
- **Docker** - Deployment

### 🚀 Getting Started

```bash
# Clone the repository
git clone https://github.com/mmsal512/tabdil-app.git
cd tabdil-app

# Install dependencies
flutter pub get

# Run the app (Web)
flutter run -d chrome

# Run the app (Mobile)
flutter run

# Build APK
flutter build apk --release

# Build Web
flutter build web --release
```

---

## 🐳 Docker Deployment

This project includes a production-ready Docker setup for deploying the Flutter Web application.

### 📁 Project Structure

```
tabdil/
├── Dockerfile              # Multi-stage build (Flutter → nginx)
├── docker-compose.yml      # Docker Compose configuration
├── docker-entrypoint.sh    # Runtime config generator
├── .env.example            # Environment variables template
├── nginx/
│   └── nginx.conf         # Optimized nginx configuration
├── secrets/
│   └── secret.yml.example # Secrets template
└── lib/
    ├── screens/
    │   ├── home_screen.dart        # Main Hyper UI screen
    │   ├── admin_login_screen.dart # Admin login
    │   └── rate_editor_screen.dart # Rate editor
    ├── widgets/
    │   └── hyper_ui.dart          # Shared UI components
    ├── services/
    │   ├── app_config.dart        # Runtime config loader
    │   ├── supabase_service.dart  # Supabase integration
    │   └── rates_service.dart     # Rates API service
    └── providers/
        └── currency_provider.dart # State management
```

### 🔐 Security: Runtime Configuration

**Important:** Secrets are NOT embedded in the Docker image. They are injected at container startup via Docker secrets.

The `docker-entrypoint.sh` script:
1. Reads secrets from `/run/secrets/app_secrets`
2. Generates `/usr/share/nginx/html/assets/config.json`
3. Starts nginx

### 📋 Setup Instructions

#### 1. Create secrets file

```bash
# Copy the template
cp secrets/secret.yml.example secrets/secret.yml

# Edit with your actual values
nano secrets/secret.yml
```

**secrets/secret.yml:**
```yaml
SUPABASE_URL: "https://your-project.supabase.co"
SUPABASE_ANON_KEY: "your-supabase-anon-key"
OPEN_EXCHANGE_API_KEY: "your-openexchangerates-app-id"
```

#### 2. Create environment file

```bash
cp .env.example .env
```

**.env:**
```env
APP_PORT=90
APP_ENV=production
```

#### 3. Build and Run

```bash
# Build the Docker image
docker-compose build

# Run the container
docker-compose up -d

# View logs
docker-compose logs -f tabdil-web

# Stop the container
docker-compose down
```

### 🌐 Access the Application

After running, access the app at:
- **Local:** http://localhost:90
- **Server:** http://your-server-ip:90

### 🔧 Configuration Options

| Variable | Description | Default |
|----------|-------------|---------|
| `APP_PORT` | External port to expose | `90` |
| `APP_ENV` | Environment (production/development) | `production` |

> **Note:** The internal nginx port is always 80. `APP_PORT` controls the external port mapping.

### 📊 Health Check

The nginx server includes a health check endpoint:

```bash
curl http://localhost:90/health
# Response: healthy
```

### 🔒 Security Features

- **No secrets in image:** All sensitive data is injected at runtime
- **Security headers:** X-Frame-Options, X-Content-Type-Options, CSP
- **Gzip compression:** Optimized for performance
- **Static caching:** Immutable assets cached for 1 year
- **SPA fallback:** Proper history API support

### 💻 How the Flutter Code Loads Config

The app loads runtime configuration from `config.json`:

```dart
// lib/services/app_config.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AppConfig {
  static late Map<String, dynamic> _config;

  static Future<void> load() async {
    final jsonStr = await rootBundle.loadString('config.json');
    _config = jsonDecode(jsonStr);
  }

  static String get supabaseUrl => _config['SUPABASE_URL'];
  static String get supabaseAnonKey => _config['SUPABASE_ANON_KEY'];
  static String get openExchangeApiKey => _config['OPEN_EXCHANGE_API_KEY'];
}
```

### 🚀 Quick Commands Reference

```bash
# Build image
docker-compose build

# Start container
docker-compose up -d

# View logs
docker-compose logs -f

# Stop container (keeps image)
docker-compose stop

# Start container (after stop)
docker-compose start

# Stop and remove container
docker-compose down

# Rebuild and restart
docker-compose up -d --build

# Check container status
docker-compose ps

# Execute shell in container
docker-compose exec tabdil-web sh
```

---

## 📱 Screenshots

The app features a stunning **Immersive Neon Glass** design:

- Animated morphic aurora background
- Glassmorphism currency cards with 3D glow
- Photo-reactive keypad buttons
- Real-time rate status with last update time

---

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Author

Developed with ❤️ for the Yemeni market.

---

<div align="center">

**⭐ Star this repo if you find it helpful! ⭐**

</div>
