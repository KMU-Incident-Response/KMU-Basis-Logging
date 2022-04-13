# Universal Installer
Der universal Installer hilft bei der Installation vom Wazuh Server, sowie auch mit dem installieren der empfohlenen Rules für KMUs.
Alle Kompenenten können einzeln installiert werden.
Bedingung für die Rules ist, dass Wazuh schon auf dem Server vorhanden ist.

## Bedienung
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
Den Installer auf GitHub herunterladen und in ein `installer.sh` schreiben.
``` bash
bash installer.sh <parameter>
```