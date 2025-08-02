#!/bin/bash
echo "🚀 Starte Setup für GlobalAkte..."

flutter create globalakte
cd globalakte || exit

# Feature-Struktur erstellen
mkdir -p lib/features/{authentication,case_timeline,communication,contact_helper,document_generator,encryption,file_storage,knowledge_base,legal_assistant_ai,shared_database,user_roles,evidence_collection,help_network,accessibility}

# Environment Setup
touch .env .env.example
echo "LLM_API_KEY=your_api_key_here" > .env
echo "ENCRYPTION_KEY=your_encryption_key_here" >> .env
echo "DATABASE_URL=your_database_url_here" >> .env

# Git Setup
git init
git add .
git commit -m "🚀 Initial Commit - GlobalAkte Setup"

echo "✅ Setup abgeschlossen. GlobalAkte bereit für Entwicklung!"