#!/bin/bash

echo "🔄 Сброс приложения TeamAI..."

# Удалить данные приложения на iOS симуляторе
xcrun simctl --set ~/Library/Developer/CoreSimulator/Devices uninstall booted com.teamai.teamai 2>/dev/null || true

# Очистить build
echo "📦 Очистка build..."
flutter clean

# Переустановить зависимости
echo "📥 Установка зависимостей..."
flutter pub get

echo "✅ Готово! Запустите: flutter run"
