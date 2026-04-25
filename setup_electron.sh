#!/usr/bin/env bash

# --- Langue ---
echo "1) English (Default)"
echo "2) Français"
echo "3) Español (España)"
echo "4) Español (América Latina)"
read -p "Option: " lang_choice

case $lang_choice in
    2) M_NAME="Nom du projet : "; M_LIC="Licence : "; M_START="Départ : "; M_URL="URL : "; M_INST="Installation d'Electron en cours..." ;;
    3|4) M_NAME="Nombre : "; M_LIC="Licencia : "; M_START="Inicio : "; M_URL="URL : "; M_INST="Instalando Electron..." ;;
    *) M_NAME="Project Name: "; M_LIC="License: "; M_START="Start: "; M_URL="URL: "; M_INST="Installing Electron..." ;;
esac

# --- Questions ---
read -p "$M_NAME" PROJECT_NAME
PROJECT_NAME=${PROJECT_NAME:-"electron-project"}

echo "1) MIT (Default) | 2) ISC | 3) GPL-3.0 | 4) Custom"
read -p "$M_LIC" lic_choice
case $lic_choice in
    2) LIC="ISC" ;; 3) LIC="GPL-3.0" ;; 4) read -p "Name: " LIC ;; *) LIC="MIT" ;;
esac

echo "1) index.html (Default) | 2) Website"
read -p "$M_START" start_choice

# --- Création du dossier et du README ---
mkdir -p "$PROJECT_NAME"

# Création du fichier README.md avec le texte demandé
echo "ADD YOU WANT HERE" > "$PROJECT_NAME/README.md"

cd "$PROJECT_NAME"

# --- Initialisation NPM et Installation Electron ---
echo "$M_INST"
npm init -y > /dev/null
npm install electron --save-dev > /dev/null

# Modification du package.json pour le point d'entrée
sed -i 's/"main": "index.js"/"main": "main.js"/' package.json
# Ajout d'un script de démarrage
sed -i 's/"test": "echo \\"Error: no test specified\\" && exit 1"/"start": "electron ."/' package.json

# --- Configuration du main.js ---
if [ "$start_choice" = "2" ]; then
    read -p "$M_URL" SITE_URL
    SITE_URL=${SITE_URL:-"https://example.com"}
    echo "const { app, BrowserWindow } = require('electron'); app.on('ready', () => { let win = new BrowserWindow({width: 1200, height: 800}); win.loadURL('$SITE_URL'); });" > main.js
else
    wget -q https://raw.githubusercontent.com/Stormwindsky/HTML-Starter-Kit/refs/heads/main/index.html
    echo "const { app, BrowserWindow } = require('electron'); app.on('ready', () => { let win = new BrowserWindow({width: 1200, height: 800}); win.loadFile('index.html'); });" > main.js
fi

echo "-----------------------------------"
echo "Terminé / Finished"
read -p "Press [Enter] to open folder and exit..."

# Ouvrir le dossier et quitter
xdg-open .
exit
