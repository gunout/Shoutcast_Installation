#!/bin/bash

# Script pour résoudre les problèmes de démarrage de Shoutcast

# Variables
SHOUTCAST_DIR="/usr/local/shoutcast"
TMP_DIR="/tmp"

# Vérifier si l'utilisateur est root
if [ "$EUID" -ne 0 ]; then
    echo "Veuillez exécuter ce script en tant que root."
    exit 1
fi

# Nettoyer le répertoire /tmp/
echo "Nettoyage du répertoire /tmp/..."
rm -rf $TMP_DIR/sc_serv2_linux_x64-latest.tar.gz $TMP_DIR/cacert.pem $TMP_DIR/DNAS_Server_Changelog.html $TMP_DIR/Readme_DNAS_Server.html $TMP_DIR/sc_serv $TMP_DIR/setup.sh $TMP_DIR/tos.txt $TMP_DIR/control $TMP_DIR/docs $TMP_DIR/examples $TMP_DIR/logs $TMP_DIR/setup

# Télécharger et extraire l'archive
echo "Téléchargement de Shoutcast Server..."
wget https://download.nullsoft.com/shoutcast/tools/sc_serv2_linux_x64-latest.tar.gz -O $TMP_DIR/shoutcast.tar.gz
tar -xvzf $TMP_DIR/shoutcast.tar.gz -C $TMP_DIR/

# Vérifier que le fichier sc_serv a été extrait
if [ ! -f "$TMP_DIR/sc_serv" ]; then
    echo "Erreur : Le fichier sc_serv n'a pas été extrait."
    exit 1
fi

# Déplacer le fichier sc_serv
echo "Déplacement du fichier sc_serv..."
mv $TMP_DIR/sc_serv $SHOUTCAST_DIR/sc_serv

# Donner les permissions d'exécution
echo "Définition des permissions..."
chmod +x $SHOUTCAST_DIR/sc_serv

# Vérifier que le fichier est exécutable
if [ ! -x "$SHOUTCAST_DIR/sc_serv" ]; then
    echo "Erreur : Le fichier sc_serv n'est pas exécutable."
    exit 1
fi

# Redémarrer le service Shoutcast
echo "Démarrage du service Shoutcast..."
systemctl restart shoutcast

# Vérifier le statut du service
echo "Vérification du statut du service..."
systemctl status shoutcast