# Bowling Frontend

Projekt **Bowling Frontend** to aplikacja internetowa stworzona przy użyciu frameworka Flutter. 
Backend dla tego projektu znajduje się pod adresem: [https://github.com/SniperMonke420/BOWling](https://github.com/SniperMonke420/BOWling).

## Wymagania wstępne

Aby uruchomić projekt lokalnie, należy upewnić się, że masz zainstalowane następujące narzędzia:
- [Flutter](https://docs.flutter.dev/get-started/install/windows/web)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Flutter extension for VSC](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
- [Chrome web browser](https://www.google.com/intl/pl_pl/chrome/)
- [Git for Windows](https://gitforwindows.org/)

## Klonowanie i konfiguracja projektu
1. **Sklonuj repozytorium**
   ```bash
   git clone https://github.com/Hignem/Bowling_Frontend.git
   cd Bowling_Frontend
   ```

2. **Zainstaluj zależności projektu**
   Upewnij się, że wszystkie wymagane pakiety zostały zainstalowane, uruchamiając polecenie:
   ```bash
   flutter pub get
   ```

## Uruchamianie projektu

1. **Sprawdź konfigurację Fluttera**
   Upewnij się, że środowisko Flutter działa poprawnie:
   ```bash
   flutter doctor
   ```
   Jeśli wystąpią problemy, postępuj zgodnie z zaleceniami wyświetlanymi w konsoli.

2. **Uruchom projekt jako stronę internetową**
   Flutter obsługuje uruchamianie projektów w przeglądarce. Aby uruchomić aplikację, wykonaj polecenie:
   ```bash
   flutter run -d chrome
   ```
   Polecenie `-d chrome` wskazuje, że aplikacja ma być uruchomiona w przeglądarce Google Chrome.

3. **Dostęp do aplikacji**
   Po pomyślnym uruchomieniu aplikacja będzie dostępna pod adresem wyświetlonym w konsoli (`http://localhost:port/`).

## Struktura projektu

- `lib/` - Główna logika aplikacji (widoki, komponenty itd.)
- `assets/` - Zasoby statyczne (obrazy itp.)

## Opis commitów
**Branch (main)**

- **Initial commit**: Inicjalizacja projektu.
- **main commit**: Utworzenie początkowych widgetów i stron.

**Branch (register)**

- **works but not correctly (CORS, 8080)**: Działające logowanie i rejestracja (problem z CORSem na wersji webowej. Debugowanie na Windows - wszystko działa prawidłowo).
- **login + name in reserv**: Logowanie działa prawidłowo i działa fetchowanie imienia po tokenie.
- **appbar update**: Teraz po zalogowaniu mamy przycisk do wylogowania w appbar.
- **app_bar update**: Naprawiono błąd, gdzie użytkownik zalogowany był w stanie przejść do strony głównej poprzez appbar.
- **change color + history button**: Poprawiono widoczność przycisków w rezerwacji i dodano historie zamówień do appbar.
- **Delete wrong text in register**: Usunięcie niepotrzebnego pola w rejestracji.
  
**Branch (reservation)**
  
- **get lines from backend**: Zaciąganie dostępnych kortów działa, wystąpiły błędy w konsoli - do poprawy.
- **cosmetic changes**: Dodanie pól osób, ceny, zmieniono kolory przycisków oraz pokazuje wyraźnie który tor jest już zajęty.
- **reservation post**: Rezerwacja w pełni działa dobrze bez błędów.
  
**Branch (history of orders)**
  
- **fetching history**: Zaciąganie podstawowych pól z historii zamówień (jeszcze bez wszystkich bo nie było na backendzie).
- **updated fetching history of orders**: Zaktualizowano fetchowanie o brakujące pola i wycentrowano dane w tabeli.
- **history finished**: Dodano przycisk umożliwiający usuwanie rezerwacji oraz przeformatowano datę na inny format.
  
**Branch (admin panel)**
  
- **Checking is admin**: Dodano logikę sprawdzającą czy użytkownik jest adminem.
- **Added button - admin panel**: Dodano przycisk "Panel administratora".
- **Create main view of admin panel**: Utworzenie wyglądu całego kontenera panelu administratora oraz fetchowanie danych.
- **Delete lane**: Dodano funkcjonalność usuwania torów.
- **LaneWindow added**: Dodano okno umożliwiające wprowadzanie i edycję toru.
- **Adding new lane**: Dodawanie nowego toru.
- **Edit lane function**: Dodano funkcjonalność edycji toru.
- **Better edit window**: Dodano funkcjonalność w której do okna dialogowego są wrzucane dane podczas naciśnięcia na przycisk edycji.
- **Deleted debug watermark**: Usunięto znak wodny "debug" aplikacji.

**Branch (main)**
  
- **Deleted widget test**: Usunięto zbędny plik który mógłby powodować błędy

Wszystkie zmiany zostały zmergowane do Branch (main).
