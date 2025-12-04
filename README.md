# 💱 Tabdil - Smart Currency Converter

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)

**تطبيق تحويل عملات ذكي بأسلوب الآلة الحاسبة**

[English](#english) | [العربية](#العربية)

</div>

---

## العربية

### 📝 نظرة عامة

**تبديل (Tabdil)** هو تطبيق تحويل عملات احترافي مصمم خصيصاً للسوق اليمني. يستخدم نظام أسعار هجين يجمع بين الأسعار اليدوية للريال اليمني (YER) وأسعار API للعملات الأجنبية.

### ✨ المميزات

- 🧮 **واجهة آلة حاسبة** - تصميم سهل الاستخدام بأسلوب الآلة الحاسبة
- 🌙 **الوضع الداكن** - تصميم عالي التباين (أسود، رمادي داكن، برتقالي)
- 🔄 **نظام أسعار هجين** - أسعار يدوية + أسعار API
- 👨‍💼 **لوحة تحكم المسؤول** - لتعديل الأسعار الاحتياطية
- 📦 **نظام احتياطي** - يعمل حتى بدون إنترنت
- 🏳️ **أعلام الدول** - باستخدام Unicode Emojis

### 💱 العملات المدعومة

| العملة | الرمز | العلم |
|--------|-------|-------|
| الريال اليمني | YER | 🇾🇪 |
| الدولار الأمريكي | USD | 🇺🇸 |
| الريال السعودي | SAR | 🇸🇦 |
| الدرهم الإماراتي | AED | 🇦🇪 |
| الدينار الكويتي | KWD | 🇰🇼 |
| الريال العماني | OMR | 🇴🇲 |

### 🛠️ التقنيات المستخدمة

- **Flutter** - إطار العمل
- **Dart** - لغة البرمجة
- **Supabase** - قاعدة البيانات والمصادقة
- **Provider** - إدارة الحالة
- **Open Exchange Rates API** - أسعار العملات العالمية

### 🚀 التثبيت والتشغيل

```bash
# استنساخ المستودع
git clone https://github.com/YOUR_USERNAME/tabdil.git
cd tabdil

# تثبيت الحزم
flutter pub get

# تشغيل التطبيق
flutter run

# بناء APK
flutter build apk --release
```

### ⚙️ الإعدادات

قم بتعديل الملف `lib/utils/constants.dart`:

```dart
class AppConstants {
  // Supabase
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // Open Exchange Rates API
  static const String openExchangeRatesAppId = 'YOUR_APP_ID';
}
```

---

## English

### 📝 Overview

**Tabdil** is a professional currency converter app designed specifically for the Yemeni market. It uses a hybrid rate system combining manual rates for Yemeni Rial (YER) and API rates for foreign currencies.

### ✨ Features

- 🧮 **Calculator-style UI** - Easy-to-use calculator interface
- 🌙 **Dark Mode** - High-contrast design (Black, Dark Grey, Orange)
- 🔄 **Hybrid Rate System** - Manual rates + API rates
- 👨‍💼 **Admin Panel** - For editing backup rates
- 📦 **Fallback System** - Works even without internet
- 🏳️ **Country Flags** - Using Unicode Emojis

### 🛠️ Tech Stack

- **Flutter** - Framework
- **Dart** - Programming Language
- **Supabase** - Database & Authentication
- **Provider** - State Management
- **Open Exchange Rates API** - Currency rates

### 🚀 Getting Started

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/tabdil.git
cd tabdil

# Install dependencies
flutter pub get

# Run the app
flutter run

# Build APK
flutter build apk --release
```

---

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Author

Developed with ❤️ for the Yemeni market.
