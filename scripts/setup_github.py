#!/usr/bin/env python3
import subprocess
import json
import sys

def run_gh_command(cmd):
    """Führt GitHub CLI Befehle aus"""
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        if result.returncode == 0:
            print(f"✅ {cmd}")
            return result.stdout
        else:
            print(f"❌ Fehler: {result.stderr}")
            return None
    except Exception as e:
        print(f"❌ Exception: {e}")
        return None

def create_labels():
    """Erstellt alle benötigten Labels"""
    labels = [
        # Sprint Labels
        ("Sprint-1-Setup", "0052CC", "Projekt Setup & Architektur"),
        ("Sprint-2-Auth", "0052CC", "Authentifizierung & Rollen"),
        ("Sprint-3-Security", "0052CC", "Lokale Sicherheit & Verschlüsselung"),
        ("Sprint-4-UI", "0052CC", "Benutzeroberfläche & Navigation"),
        ("Sprint-5-Knowledge", "0052CC", "Wissensdatenbank & Suche"),
        ("Sprint-6-Database", "5319E7", "Zentrale Datenbanklogik"),
        ("Sprint-7-Case-Files", "5319E7", "Fallakte & ePA"),
        ("Sprint-8-Timeline", "5319E7", "Timeline-Modul"),
        ("Sprint-9-Evidence", "5319E7", "Beweissicherung"),
        ("Sprint-10-Deletion", "5319E7", "Löschlogik"),
        
        # Feature Labels
        ("authentication", "D73A4A", "Authentifizierung & Login"),
        ("case-management", "D73A4A", "Fallakten-Verwaltung"),
        ("communication", "D73A4A", "Verschlüsselte Kommunikation"),
        ("document-generator", "D73A4A", "PDF & Dokument-Generator"),
        ("encryption", "D73A4A", "Verschlüsselung & Sicherheit"),
        ("llm-integration", "D73A4A", "KI-Integration & LLM"),
        ("accessibility", "D73A4A", "Barrierefreiheit"),
        
        # Priority Labels
        ("priority-critical", "B60205", "Kritisch - Sofort beheben"),
        ("priority-high", "FF9500", "Hoch - Nächster Sprint"),
        ("priority-medium", "FBCA04", "Mittel - Geplant"),
        ("priority-low", "28A745", "Niedrig - Backlog"),
        
        # Type Labels
        ("bug", "D73A4A", "Fehlerbehebung"),
        ("feature", "A2EEEF", "Neue Funktion"),
        ("enhancement", "7057FF", "Verbesserung"),
        ("documentation", "0075CA", "Dokumentation"),
    ]
    
    print("📋 Erstelle Labels...")
    for name, color, description in labels:
        cmd = f'gh label create "{name}" --color "{color}" --description "{description}"'
        run_gh_command(cmd)

def create_milestones():
    """Erstellt alle Milestones"""
    milestones = [
        ("MVP Foundation", "Grundlagen, Auth, UI, Wissensdatenbank", "2024-12-31"),
        ("Core Database", "Zentrale Datenbank, Fallakte, Timeline", "2025-01-31"),
        ("AI & Documents", "LLM-Integration, Schreibassistent, PDF-Export", "2025-02-28"),
        ("Communication", "Verschlüsselte Kommunikation, DSGVO", "2025-03-31"),
        ("Community", "Hilfenetzwerk, Support-Features", "2025-04-30"),
        ("Accessibility", "Barrierefreiheit, Mehrsprachigkeit", "2025-05-31"),
        ("Launch Ready", "Testing, Deployment, Launch", "2025-06-30"),
    ]
    
    print("🎯 Erstelle Milestones...")
    for title, description, due_date in milestones:
        cmd = f'gh api repos/:owner/:repo/milestones --method POST --field title="{title}" --field description="{description}" --field due_on="{due_date}T23:59:59Z"'
        run_gh_command(cmd)

def main():
    print("🚀 Starte GitHub Setup für GlobalAkte...")
    
    # Prüfe ob GitHub CLI verfügbar
    if not run_gh_command("gh --version"):
        print("❌ GitHub CLI nicht gefunden. Installiere mit: brew install gh")
        sys.exit(1)
    
    # Prüfe Authentifizierung
    if not run_gh_command("gh auth status"):
        print("❌ Nicht bei GitHub angemeldet. Führe aus: gh auth login")
        sys.exit(1)
    
    create_labels()
    create_milestones()
    
    print("✅ GitHub Setup abgeschlossen!")
    print("🔗 Öffne: https://github.com/$(gh repo view --json owner,name -q '.owner.login + \"/\" + .name')")

if __name__ == "__main__":
    main() 