# Universal Installer
Der universal Installer hilft bei der Installation vom Wazuh Server, sowie auch mit dem installieren der empfohlenen Rules für KMUs.
Alle Kompenenten können einzeln installiert werden.
Bedingung für die Rules ist, dass Wazuh schon auf dem Server vorhanden ist.

## Voraussetzungen
Die Installation ausgelegt auf KMUs und bietet sinnvolle Standardeinstellungen.

**Achtung:** Zur Zeit werden nur debian basierte Systeme unterstützt. Es wird [Ubuntu 20.04 LTS](https://releases.ubuntu.com/20.04.4/ubuntu-20.04.4-live-server-amd64.iso) empfohlen.

## Installation
![GitHub](https://img.shields.io/badge/Installationszeit-30%20Minuten-informational)

Die Installation wird über den universal Installer verrichten und kann wie folgt vorgenommen werden:

1. Login als Root auf dem zukünftigen Wazuh Server
2. Installieren von Wazuh **mit** vorbereiteten Regeln
``` bash 
curl -s https://raw.githubusercontent.com/KMU-Incident-Response/KMU-Basis-Logging/main/universal_installer/installer.sh | bash -s -- -a
```
Am Ende des Installers werden in der Shell alle gesetzten Passwörter angezigt. **Diese sollten sicher aufbewahrt werden!**

3. Login auf dem Web UI mit dem Elastic User und dem Passwort in der Shell ersichtlich.


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

### Weiteres vorgehen
Wazuh braucht noch weitere Software, um voll funktionsfähig zu sein. 
Anleitung für die Installation dieser Software findest du im [Installationsguide](https://github.com/KMU-Incident-Response/KMU-Security-Best-Practices/releases/latest/download/installation-guide-OSS.pdf)

--- 


## Allgemeine Bedienung Universal Installer
Der Wazuhinstaller kann automatisch mit `curl` ausgeführt werden oder manuell heruntergeladen werden und als CLI Tool verwendet werden.

### Parameter
Der Installer bietet folgende Parameteroptionen. Alle Parameter sind exklusiv und können nicht kombiniert werden.
``` bash
root@ubuntu:~# ./installer.sh -h
script usage:
 -a	 Install Wazuh server and rules
 -n	 no rules (Install server without rules)
 -o	 only rules (Install only custom rules, no server)
 -h	 print usage
```

Es ist möglich zuerst den Parameter `-n` und nachher den Parameter `-o` zu verwenden. Es ist nicht empfohlen die Parameter `-a, -n` mehrmals auf der selben Maschine auszuführen.

### Automatisch
Im Code unten muss der Parameter an der Stelle `<parameter>` eingefügt werden.
``` bash
curl -s https://raw.githubusercontent.com/KMU-Incident-Response/KMU-Basis-Logging/main/universal_installer/installer.sh | bash -s -- <parameter>
```

### Manuell
Den Installer auf GitHub herunterladen und in ein `installer.sh` schreiben. Im Code unten muss der Parameter an der Stelle `<parameter>` eingefügt werden.
``` bash
bash installer.sh <parameter>
```
