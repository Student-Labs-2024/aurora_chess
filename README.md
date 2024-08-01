# ChessKnock - Шахматы на ОС Аврора

## О чём наше приложение

**ChessKnock** - первое приложение на ОС Аврора, в котором можно поиграть в шахматы, как с компьютером, так и с друзьями.

## Особенности

**Дизайн:** Приложение обладает стильным, самобытным дизайном, есть как светлая тема, так и тёмная.

**Игра с компьютером:** В приложении есть возможность игры с компьютером на трёх уровнях сложности: лёгкий, средний и сложный, а также есть возможность настроить его под себя, выбрав нужные опции: подсказки, угрозы, возвраты ходов.

**Игра с другом:** В приложении можно играть с друзьями как локально на одном устройстве, так и по сети.

**Справочник:** В приложении предусмотрен справочник, в котором можно посмотреть информацию по каждой фигуре, а также по специфичным ходам, с иллюстрациями.

**Кроссплатформенность:** Помимо ОС Аврора, приложение также работает на ОС Андроид и IOS.

## Технологии
### Frontend:
- Flutter: 3.16.2-2
- Dart: 3.4.3
- C++: 16
### Backend
- Python: 3.8+

## Внешние зависимости
### Frontend:
- cupertino_icons: 1.0.6
- provider: 6.0.5
- flame: 1.7.3
- url_launcher: 6.0.2
- sqflite: 2.3.0
- flutter_svg: 2.0.10+1
- wheel_chooser: 1.1.2
- carousel_slider: 4.2.1
- sqflite_aurora: 0.5.0
### Backend:
- python-chess: 1.10.0
- fastapi: 0.111.1
- uvicorn: 0.30.3
- pytest: 8.3.1 
- pytest-cov: 5.0.0 

## Среда разработки
- Android Studio Koala 2024.1.1

## Поддерживаемые платформы
- Аврора версии 5.0.0.60 и выше
- Android версии 7 и выше
- iOS версии 12 и выше

## Требования к запуску на Авроре:
- Использование дистрибутива Linux (пример для Ubuntu 22.04)
- Установка Aurora PSDK версии не ниже 5.0.0.60
- Установка Flutter Aurora версии 3.16.2-2

## Запуск проекта
### Клонирование проекта с GitHub:
```bash
git clone https://github.com/Student-Labs-2024/aurora_chess.git -b develop
cd aurora_chess
```
### Установка зависимостей:

- для Android:
```bash
flutter pub get
```
- для Авроры:
```bash
flutter-aurora pub get
```
### Сборка приложения:

- Под Android:
```bash
flutter build apk --release
```

- Под Аврору (требуется Aurora SDK):
```bash
flutter-aurora build aurora --release
```

- Подпись пакета сертефикатом и ключом (можно использовать тестовые):

Скачать тестовый сертификат и ключ можно на сайте: https://developer.auroraos.ru/doc/software_development/guides/package_signing#public_certificates
```bash
aurora_psdk rpmsign-external sign --key <ПУТЬ к КЛЮЧУ> --cert <ПУТЬ к СЕРТИФИКАТУ> <ПУТЬ к ПАКЕТУ>
```

### Расположение установочного файла внутри проекта:

- Android: build/app/outputs/flutter-apk/app-release.apk

- Аврора: build/aurora/psdk/aurora-arm/release/RPMS/com.example.aurora_chess-0.1.0-1.armv7hl.rpm

Далее нужно перенести установочный файл на устройство и запустить его установку.
