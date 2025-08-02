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

## 🛠️ Entwicklung

### Voraussetzungen

- Flutter 3.16+
- Dart 3.2+
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

### Cursor IDE Integration

Das Projekt ist für Cursor IDE optimiert mit:

- **GitHub Integration**: Issue Templates, Labels, Milestones
- **Keyboard Shortcuts**: 
  - `Ctrl+Shift+I`: Issue erstellen
  - `Ctrl+Shift+S`: Sprint anzeigen
  - `Ctrl+Shift+P`: Pull Request erstellen
- **Tasks**: Automatisierte GitHub-Workflows

### Projekt-Struktur

```
lib/
├── features/           # Feature-basierte Architektur
│   ├── authentication/ # Login, PIN, Biometrie
│   ├── case_timeline/ # Fallakten & Timeline
│   ├── communication/ # Verschlüsselte Kommunikation
│   ├── document_generator/ # PDF & Dokumente
│   ├── encryption/    # Verschlüsselung & Sicherheit
│   ├── legal_assistant_ai/ # LLM-Integration
│   └── accessibility/ # Barrierefreiheit
└── main.dart          # App-Einstiegspunkt
```

## 📋 Sprint-Plan

| Sprint | Fokus | Deadline |
|--------|-------|----------|
| Sprint 1 | Setup & Architektur | Dez 2024 |
| Sprint 2 | Authentifizierung | Dez 2024 |
| Sprint 3 | Sicherheit & Verschlüsselung | Dez 2024 |
| Sprint 4 | UI & Navigation | Dez 2024 |
| Sprint 5 | Wissensdatenbank | Dez 2024 |

## 🤝 Beitragen

1. **Issue erstellen**: Verwende die GitHub Issue Templates
2. **Branch erstellen**: `git checkout -b feature/neue-funktion`
3. **Code schreiben**: Folge den Flutter Best Practices
4. **Pull Request**: Verwende die PR-Template

## 📄 Lizenz

Dieses Projekt steht unter der MIT-Lizenz - siehe [LICENSE](LICENSE) für Details.

## 🔗 Links

- [GitHub Issues](https://github.com/jchillah/globalakte/issues)
- [Projekt-Board](https://github.com/jchillah/globalakte/projects)
- [Wiki](https://github.com/jchillah/globalakte/wiki)
# globalakte
