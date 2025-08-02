#!/bin/bash

# GlobalAkte GitHub Shortcuts
# Verwendung: ./scripts/gh_shortcuts.sh [command]

case "$1" in
    "issue")
        echo "🔗 Öffne GitHub Issue erstellen..."
        gh issue create --web
        ;;
    "sprint")
        echo "📋 Zeige aktuelle Sprint Issues..."
        gh issue list --label "Sprint-1-Setup" --state open
        ;;
    "pr")
        echo "🔗 Öffne GitHub Pull Request erstellen..."
        gh pr create --web
        ;;
    "setup")
        echo "🚀 Führe GitHub Setup aus..."
        python3 scripts/setup_github.py
        ;;
    "sprint-issues")
        echo "📝 Erstelle Sprint Issues..."
        python3 scripts/create_project_board.py
        ;;
    *)
        echo "GlobalAkte GitHub Shortcuts"
        echo ""
        echo "Verwendung: ./scripts/gh_shortcuts.sh [command]"
        echo ""
        echo "Commands:"
        echo "  issue        - Issue erstellen"
        echo "  sprint       - Sprint Issues anzeigen"
        echo "  pr           - Pull Request erstellen"
        echo "  setup        - GitHub Setup ausführen"
        echo "  sprint-issues - Sprint Issues erstellen"
        ;;
esac 