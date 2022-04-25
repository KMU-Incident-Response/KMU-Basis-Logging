![GitHub](https://img.shields.io/github/license/KMU-Incident-Response/KMU-Basis-Logging)
# KMU Basis Logging

Für eine Übersicht über das gesamte KMU-Incident-Response Projekt, starte bitte bei [KMU-Incident-Response](https://github.com/KMU-Incident-Response).

## Inhalt
Dieses Repository stellt foglende Komponenten zur Verfügung:

| Unterverzeichnis       | Inhalt                                      |
| ---------------------- | ------------------------------------------- |
| `universal_installer/` | Installer für Wazuh Server und Custom Rules |
| `wazuh_server/`        | Basisinstallation ohne Rules                |
| `custom_rules/`        | Logging Rules für Wazuh ausgelegt auf KMUs  |

## Quick Start
Es wird empfohlen die vollständige Installation vorzunehmen.
Die vollständige Installation wird [hier](universal_installer/README.md#Installation) erklärt.

## Basic Installation
Falls nur ein Wazuh Server gewünscht ist, kann dieser ohne jegliche zusätzlichen Rules [hier](wazuh_server/README.md#Installation) installiert werden.
