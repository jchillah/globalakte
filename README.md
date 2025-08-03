# 🏛️ GlobalAkte

**Sichere App für rechtliche Selbsthilfe**

Eine Flutter-basierte mobile Anwendung, die Bürgern bei rechtlichen Angelegenheiten hilft - mit Fokus auf Datenschutz, Verschlüsselung und benutzerfreundliche Bedienung.

## 🚀 Features

- 🔐 **Sichere Authentifizierung** - PIN & biometrische Authentifizierung
- 📁 **Fallakten-Verwaltung** - Digitale Akten mit ePA-Integration
- 🤖 **KI-gestützte Hilfe** - LLM-Integration für rechtliche Beratung
- 📄 **Dokument-Generator** - Automatische PDF-Erstellung
- 🔒 **End-to-End Verschlüsselung** - Alle Daten lokal verschlüsselt
- ♿ **Barrierefreiheit** - Vollständig zugänglich für alle Nutzer
- 📅 **Terminverwaltung** - Kalender-System für rechtliche Termine
- 💬 **Kommunikation** - Verschlüsselte Nachrichten zwischen Beteiligten

## ✅ Abgeschlossene Sprints

### Sprint 1: Setup & Architektur ✅
- **Clean Architecture** implementiert
- **Features First** Struktur
- **Repository Pattern** für alle Features
- **GitHub Integration** mit Labels und Milestones

### Sprint 2: Authentifizierung ✅
- **PIN-Setup** und -Verifikation
- **Biometrische Authentifizierung** (Fingerabdruck, Face ID)
- **Sichere Speicherung** mit flutter_secure_storage
- **Benutzer-Rollen** (Bürger, Anwalt, Gericht, etc.)

### Sprint 3: Sicherheit & Verschlüsselung ✅
- **Verschlüsselung Demo** vollständig funktional
- **Schlüssel-Verwaltung** mit UI
- **Verschlüsselung/Entschlüsselung** von Text
- **Passwort-Hashing** und -Verifikation
- **Performance-Benchmark** für Verschlüsselung
- **Code-Qualität** verbessert (KISS, DRY, Clean Code)

### Sprint 4: UI & Navigation ✅
- **Welcome Screen** mit Feature-Navigation
- **Home Screens** für verschiedene Benutzer-Rollen
- **Responsive Design** für alle Bildschirmgrößen
- **Intuitive Navigation** zwischen Features

### Sprint 5: Wissensdatenbank ✅
- **Rechtliche Informationen** strukturiert
- **Suchfunktion** für relevante Gesetze
- **Kategorisierung** nach Rechtsgebieten
- **Offline-Zugriff** auf wichtige Informationen

### Sprint 6: Dokumenten-Management ✅
- **Dokument-Erstellung** und -Verwaltung
- **PDF-Generator** für rechtliche Dokumente
- **Cloud-Synchronisation** mit Backup
- **Versionierung** und Änderungsverfolgung

### Sprint 7: Terminverwaltung & Kalender ✅
- **Kalender-System** für rechtliche Termine
- **Termin-Erstellung** und -Verwaltung
- **Erinnerungen** und Notifikationen
- **Integration** mit Fallakten

### Sprint 8: Barrierefreiheit & Accessibility ✅
- **Screen Reader** Unterstützung für alle UI-Elemente
- **Voice Control** für Navigation und Aktionen
- **High Contrast Mode** für bessere Sichtbarkeit
- **Skalierbare Schriftgrößen** (0.5x - 3.0x)
- **Vollständige Tastaturnavigation**
- **Focus-Indikatoren** für bessere Orientierung
- **Motion Reduction** für empfindliche Benutzer
- **WCAG 2.1 AA Konformität**
- **Accessibility Testing** Suite implementiert

## 🛠️ Entwicklung

### Voraussetzungen

- Flutter 3.32+
- Dart 3.8+
- GitHub CLI (`gh`)

### Setup

1. **Repository klonen**

   ```bash
   git clone https://github.com/jchillah/globalakte.git
   cd globalakte
   ```

2. **Dependencies installieren**

   ```bash
   flutter pub get
   ```

3. **GitHub Setup ausführen**

   ```bash
   # Labels und Milestones erstellen
   python3 scripts/setup_github.py

   # Sprint Issues erstellen
   python3 scripts/create_project_board.py
   ```

### VSCode IDE Integration

Das Projekt ist für VSCode IDE optimiert mit:

- **GitHub Integration**: Issue Templates, Labels, Milestones
- **Keyboard Shortcuts**:
  - `Ctrl+Shift+I`: Issue erstellen
  - `Ctrl+Shift+S`: Sprint anzeigen
  - `Ctrl+Shift+R`: Pull Request erstellen
  - `Ctrl+Shift+B`: GitHub Setup
  - `Ctrl+Shift+N`: Sprint Issues erstellen
- **Tasks**: Automatisierte GitHub-Workflows

**Alternative (falls Shortcuts nicht funktionieren):**

```bash
./scripts/gh_shortcuts.sh [command]
# Commands: issue, sprint, pr, setup, sprint-issues
```

### Projekt-Struktur

```
lib/
├── features/           # Feature-basierte Architektur
│   ├── accessibility/ # Barrierefreiheit & Accessibility
│   ├── authentication/ # Login, PIN, Biometrie
│   ├── case_timeline/ # Fallakten & Timeline
│   ├── communication/ # Verschlüsselte Kommunikation
│   ├── document_management/ # PDF & Dokumente
│   ├── encryption/    # Verschlüsselung & Sicherheit
│   ├── appointment/   # Terminverwaltung & Kalender
│   ├── legal_assistant_ai/ # LLM-Integration
│   └── welcome/       # Welcome Screen & Navigation
├── shared/            # Gemeinsame Widgets & Utils
├── core/              # App-Konfiguration & Theme
└── main.dart          # App-Einstiegspunkt
```

## 🏗️ Architektur

### Clean Architecture
- **Domain Layer**: Entities, Repository Interfaces, Use Cases
- **Data Layer**: Repository Implementations, Data Sources
- **Presentation Layer**: Screens, Widgets, State Management

### Features First
Jedes Feature ist in sich geschlossen mit:
- `data/` - Repository Implementations
- `domain/` - Entities, Repositories, Use Cases
- `presentation/` - Screens und Widgets

### Repository Pattern
- Abstrakte Repository Interfaces
- Mock Implementations für Demo
- Einfacher Austausch der Datenquellen

## 📊 Technische Qualität

### Code-Qualität
- **KISS** (Keep It Simple, Stupid)
- **DRY** (Don't Repeat Yourself)
- **Clean Code** Standards
- **Single Responsibility Principle**
- **Separation of Concerns**

### Testing
- **Unit Tests** für Use Cases
- **Widget Tests** für UI-Komponenten
- **Integration Tests** für Features
- **Accessibility Tests** für Barrierefreiheit

### Performance
- **Lazy Loading** für große Datenmengen
- **Memory Management** mit dispose()
- **Optimierte Widgets** mit const Constructors
- **Benchmark-Tests** für kritische Funktionen

## 📋 Nächste Sprints

| Sprint   | Fokus                        | Status |
| -------- | ---------------------------- | ------ |
| Sprint 9 | KI-Integration & LLM         | 🔄 Geplant |
| Sprint 10| ePA-Integration              | 🔄 Geplant |
| Sprint 11| Offline-Funktionalität       | 🔄 Geplant |
| Sprint 12| Performance-Optimierung      | 🔄 Geplant |

## 🤝 Beitragen

1. **Issue erstellen**: Verwende die GitHub Issue Templates
2. **Branch erstellen**: `git checkout -b feature/neue-funktion`
3. **Code schreiben**: Folge den Flutter Best Practices
4. **Pull Request**: Verwende die PR-Template

### Coding Standards
- **Deutsche Kommentare** und Dokumentation
- **Semantic Commits** mit Präfixen
- **Linter-Regeln** befolgen
- **Accessibility** bei allen UI-Elementen

## 📄 Lizenz

Dieses Projekt steht unter der MIT-Lizenz - siehe [LICENSE](LICENSE) für Details.

## 🔗 Links

- [GitHub Issues](https://github.com/jchillah/globalakte/issues)
- [Projekt-Board](https://github.com/jchillah/globalakte/projects)
- [Wiki](https://github.com/jchillah/globalakte/wiki)

---

**Entwickelt mit ❤️ für die digitale Transformation der Rechtshilfe**
