# Arluis TV 📺

App IPTV tipo Netflix para Android y Android TV Box.

## Características
- Login con credenciales de Xtream UI (sin exponer IP del servidor)
- Canales en vivo con reproductor VLC
- Películas y Series con portadas
- Búsqueda en tiempo real
- Compatible con Android Phone y TV Box

## Cómo compilar la APK (sin Android Studio)

### Opción 1: Codemagic (recomendado)
1. Sube este proyecto a GitHub
2. Ve a https://codemagic.io y conecta tu GitHub
3. Selecciona este repositorio
4. Codemagic detecta el `codemagic.yaml` automáticamente
5. Haz clic en **Start build**
6. Descarga la APK cuando termine (~10 minutos)

### Opción 2: Local con Flutter instalado
```bash
flutter pub get
flutter build apk --release
# APK en: build/app/outputs/flutter-apk/app-release.apk
```

## Cambiar servidor
Edita `lib/services/xtream_service.dart`:
```dart
static const String _server = 'TU_IP_PUBLICA:PUERTO';
```

## Estructura
```
lib/
  main.dart              # Entrada de la app
  screens/
    login_screen.dart    # Pantalla de login
    home_screen.dart     # Canales, VOD, Series
    player_screen.dart   # Reproductor VLC
  models/
    channel.dart         # Modelo canal
    vod.dart             # Modelo VOD/Series
  services/
    xtream_service.dart  # API Xtream UI
```
