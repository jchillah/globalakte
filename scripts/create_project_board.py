#!/usr/bin/env python3
import subprocess
import json

def create_project_board():
    """Erstellt GitHub Project Board"""
    
    print("🏗️ Project Board wird erstellt...")
    print("⚠️ Führe diesen Befehl manuell aus:")
    print("gh project create --title 'GlobalAkte Development Board' --body 'Hauptentwicklungsboard für GlobalAkte App'")

def create_sprint_issues():
    """Erstellt die ersten Sprint Issues"""
    
    issues = [
        {
            "title": "🚀 Flutter Projekt Setup & Architektur",
            "body": """## 📋 Beschreibung
Grundlegendes Flutter Projekt mit Feature-First Architektur erstellen

## ✅ Acceptance Criteria
- [ ] Flutter Projekt erstellt (flutter create globalakte)
- [ ] Feature-Ordner angelegt (authentication, case_timeline, etc.)
- [ ] pubspec.yaml mit allen Abhängigkeiten konfiguriert
- [ ] .env Setup für Konfiguration
- [ ] GitHub Repository verbunden und Initial Commit

## 🔧 Technical Notes
- Flutter 3.16+ verwenden
- Riverpod für State Management
- Hive für lokale Datenbank
- Feature-First Architektur befolgen

## 📱 Files zu erstellen
- `lib/main.dart`
- `lib/features/` (alle Unterordner)
- `pubspec.yaml`
- `.env` und `.env.example`
- `README.md`

## ⏱️ Time Estimate
1 Tag""",
            "labels": "Sprint-1-Setup,feature,priority-critical",
            "milestone": "MVP Foundation"
        },
        {
            "title": "🔐 Benutzer-Authentifizierung Interface",
            "body": """## 📋 Beschreibung
Login/Register Screen mit Rollenauswahl implementieren

## ✅ Acceptance Criteria
- [ ] Login Screen UI mit Material Design 3
- [ ] Register Screen mit Rollenauswahl (Bürger, Behörde, Gericht, etc.)
- [ ] Input Validation für alle Felder
- [ ] Navigation zwischen Login/Register
- [ ] Responsive Design für verschiedene Bildschirmgrößen
- [ ] Accessibility Support (Screenreader-kompatibel)

## 🎨 UI Requirements
- Material Design 3 Guidelines befolgen
- Rolle-spezifische Icons verwenden
- Intuitive Benutzerführung
- Farbschema: Professionell, vertrauenswürdig

## 🔧 Technical Notes
- `flutter_riverpod` für State Management
- Form Validation mit Flutter Forms
- Navigator 2.0 für Routing

## ⏱️ Time Estimate
2 Tage""",
            "labels": "Sprint-2-Auth,authentication,feature,priority-high",
            "milestone": "MVP Foundation"
        },
        {
            "title": "🔒 PIN & Biometrische Authentifizierung",
            "body": """## 📋 Beschreibung
Lokale Sicherheit mit PIN und biometrischer Authentifizierung implementieren

## ✅ Acceptance Criteria
- [ ] PIN Setup Flow (Ersteinrichtung)
- [ ] PIN Verification bei App-Start
- [ ] Biometrische Authentifizierung (FaceID/Fingerprint)
- [ ] Secure Storage für sensitive Daten
- [ ] AES256 Verschlüsselung für lokale Daten
- [ ] Fallback-Mechanismen bei Biometrie-Fehlern
- [ ] PIN Reset Funktion

## 🔧 Technical Implementation
- `local_auth` package für Biometrie
- `flutter_secure_storage` für sichere lokale Speicherung
- `encrypt` package für AES256
- Custom PIN Input Widget

## 🛡️ Security Requirements
- Keine Klartextspeicherung von PINs
- Biometrische Daten bleiben auf Device
- Timeout nach mehreren Fehlversuchen

## ⏱️ Time Estimate
2 Tage""",
            "labels": "Sprint-3-Security,authentication,encryption,priority-high",
            "milestone": "MVP Foundation"
        }
    ]
    
    print("📝 Erstelle Sprint Issues...")
    for issue in issues:
        # Escape quotes für Shell
        title = issue["title"].replace('"', '\\"')
        body = issue["body"].replace('"', '\\"').replace('\n', '\\n')
        
        cmd = f'''gh issue create --title "{title}" --body "{body}" --label "{issue['labels']}" --milestone "{issue['milestone']}"'''
        
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        if result.returncode == 0:
            print(f"✅ Issue erstellt: {issue['title']}")
        else:
            print(f"❌ Fehler: {result.stderr}")

if __name__ == "__main__":
    create_project_board()
    create_sprint_issues() 