# Wazuh Server Installer
Hier befinden sich alle Files benötigt für eine Basisinstallation von [Wazuh](https://wazuh.com/).

# Installation
Die komplette Installation (empfohlen) wird über den [universal Installer](../universal_installer/README.md#Installation) gemacht.

## manuelle Server Installation ohne Rules
1. Login als Root auf dem zukünftigen Wazuh Server
2. Installieren von Wazuh **ohne** vorbereitete Regeln
``` bash 
curl -s https://raw.githubusercontent.com/KMU-Incident-Response/KMU-Basis-Logging/main/universal_installer/installer.sh | bash -s -- -n
```
3. Login auf dem Web UI mit dem Elastic User und dem Passwort in der Shell ersichtlich
