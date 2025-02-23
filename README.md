# Shoutcast Configuration ( server )

Configure ton server (ligne 50 a 78 ):


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

# Shoutcast_Installation 
Automate Shoutcast Installation &amp;&amp; Configuration 


    chmod +x shoutcast_config.sh
    sudo ./shoutcast_config.sh

# Fix ( Si apres l'installation ton server n'est pas actif utilise ) :

        chmod +x fix_shoutcast.sh
        sudo ./fix_shoutcast.sh



____________________________________________________________________________________   By Gunout 2025

        
