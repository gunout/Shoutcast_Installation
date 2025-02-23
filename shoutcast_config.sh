#!/bin/bash

# Script pour installer et configurer un serveur Shoutcast

# Variables
SHOUTCAST_DIR="/usr/local/shoutcast"
CONFIG_FILE="$SHOUTCAST_DIR/sc_serv.conf"
SERVICE_FILE="/etc/systemd/system/shoutcast.service"
IP_PUBLIC=$(curl -s ifconfig.me)

# Fonction pour afficher les messages
log() {
    echo -e "\n[INFO] $1"
}

# Vérifier si l'utilisateur est root
if [ "$EUID" -ne 0 ]; then
    echo "Veuillez exécuter ce script en tant que root."
    exit 1
fi

# Mettre à jour le système
log "Mise à jour du système..."
apt-get update -y
apt-get upgrade -y

# Installer les dépendances
log "Installation des dépendances..."
apt-get install -y wget unzip libc6 libstdc++6

# Télécharger Shoutcast Server
log "Téléchargement de Shoutcast Server..."
wget https://download.nullsoft.com/shoutcast/tools/sc_serv2_linux_x64-latest.tar.gz -O /tmp/shoutcast.tar.gz

# Extraire l'archive
log "Extraction de l'archive..."
tar -xvzf /tmp/shoutcast.tar.gz -C /tmp/

# Créer le répertoire Shoutcast
log "Création du répertoire Shoutcast..."
mkdir -p $SHOUTCAST_DIR
mv /tmp/sc_serv2 $SHOUTCAST_DIR/sc_serv
mv /tmp/sc_serv.conf $SHOUTCAST_DIR/sc_serv.conf

# Configurer Shoutcast
log "Configuration de Shoutcast..."
cat <<EOL > $CONFIG_FILE
; Configuration de base pour Shoutcast Server

; Port de base
portbase=8000

; Mot de passe administrateur
adminpassword=admin

; Mot de passe pour les sources (streaming)
password=source

; Nom de la station
streamname=Ma Station Shoutcast

; Description de la station
streamdescription=Diffusion en direct sur le réseau local

; URL de la station
streamurl=http://$IP_PUBLIC:8000

; Genre de la station
streamgenre=Variété

; Nombre maximum d'auditeurs
maxuser=10

; Encodage audio (par défaut : MP3)
encoder=mp3

; Bitrate (128 kbps par défaut)
bitrate=128
EOL

# Donner les permissions d'exécution
log "Définition des permissions..."
chmod +x $SHOUTCAST_DIR/sc_serv
chmod 644 $CONFIG_FILE

# Configurer le service systemd
log "Configuration du service systemd..."
cat <<EOL > $SERVICE_FILE
[Unit]
Description=Shoutcast Server
After=network.target

[Service]
ExecStart=$SHOUTCAST_DIR/sc_serv $CONFIG_FILE
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOL

# Recharger systemd et démarrer le service
log "Démarrage du service Shoutcast..."
systemctl daemon-reload
systemctl enable shoutcast
systemctl start shoutcast

# Vérifier le statut du service
log "Vérification du statut du service..."
systemctl status shoutcast

# Afficher les informations de connexion
log "Serveur Shoutcast installé et configuré !"
echo "URL de diffusion : http://$IP_PUBLIC:8000"
echo "Mot de passe administrateur : admin"
echo "Mot de passe source : source"

# Fin du script
log "Installation terminée !"