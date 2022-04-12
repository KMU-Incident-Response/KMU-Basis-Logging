# Wazuh Server Installer
Hier befinden sich alle Files benötigt für eine Basisinstallation von [Wazuh](https://wazuh.com/).

## Voraussetzungen
Die Installation ausgelegt auf KMUs und bietet sinnvolle Standardeinstellungen.

**Achtung:** Zur Zeit werden nur debian basierte Systeme unterstützt. Es wird [Ubuntu 20.04 LTS](https://releases.ubuntu.com/20.04.4/ubuntu-20.04.4-live-server-amd64.iso) empfohlen.

## Installation
Die Installation kann wie folgt vorgenommen werden:

1. Login als Root auf dem zukünftigen Wazuh Server
2. Installieren von Wazuh mit dem Installer
``` bash 
wget -O - https://raw.githubusercontent.com/KMU-Incident-Response/KMU-Basis-Logging/main/wazuh_server/installer.sh | bash
```
3. Login auf dem Web UI mit dem Elastic User und dem Passwort in der Shell ersichtlich


### Firewall
Wenn eine Firewall verwendet wird müssen folgende Ports freigeschaltet werden.
``` bash
443/tcp         -  Kibana web interface
514/UDP/tcp     -  Syslog
1514/UDP/tcp    -  To get events from the agent.
1515/tcp        -  Port Used for agent Registration.
1516/tcp        -  Wazuh Cluster communications.
9200/tcp        -  Elasticsearch API
55000/tcp       -  Wazuh API port for incoming requests.
```
Mit folgendem Command kann dies auf ufw erreicht werden. (Default auf Ubuntu)
``` bash
ufw allow to any proto udp port 514,1514
ufw allow to any proto tcp port 443,514,1514,1515,1516,9200,55000
```
Mit folgendem Command kann dies auf firewalld erreicht werden.
``` bash
firewall-cmd --permanent --add-port={443,514,1514,1515,1516,9200,55000}/tcp
firewall-cmd --permanent --add-port={514,1514}/udp
firewall-cmd --reload
```
