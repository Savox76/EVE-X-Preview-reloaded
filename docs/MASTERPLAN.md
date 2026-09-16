# Entwicklungs-Masterplan

Stand: 16. September 2026

Dieser Plan bündelt die nächsten möglichen Entwicklungsschritte für EVE-X-Preview Reloaded. Er ist eine Entscheidungshilfe, keine Zusage, alle Pakete umzusetzen. Ein Paket beginnt erst, wenn es ausdrücklich gewünscht wird.

## Leitplanken

- Veröffentlicht wird ausschließlich ein portables ZIP; kein Installer und kein einzelner EXE-Download.
- Die Oberfläche bleibt vollständig auf Deutsch und Englisch nutzbar.
- Bestehende `EVE-X-Preview.json`-Dateien bleiben kompatibel. Neue Einstellungen erhalten sichere Standardwerte.
- Jedes Paket bleibt möglichst klein und erhält einen eigenen Pull Request.
- Zusammengeführt wird erst nach erfolgreicher Projektprüfung und grünem Windows-Build.
- Eine neue Programmversion und ein GitHub-Release gibt es nur bei Änderungen am Programm. Reine Dokumentationsänderungen erhöhen die Version nicht.
- Funktionen, die Eingaben an mehrere EVE-Clients senden, bleiben ausgeschlossen.

## Aktueller Stand

| Paket | Version | Inhalt | Status |
| --- | --- | --- | --- |
| 1 – Portable Grundlage | `1.1.0-preview.1` | Deutscher/englischer Sprachwechsel, Update-Hinweis über GitHub, reproduzierbares portables ZIP | Erledigt |
| 2 – Farben und Clientnamen | `1.1.0-preview.2` | Windows-Farbpalette mit HEX-/RGB-Übernahme, automatische Clientnamen, Entfernung der Beispielnamen, sichere Titelbereinigung | Erledigt |
| 3 – Profile und Layout-Sperre | `1.1.0-preview.3` | Aktive Clients sofort in neuen Profilen, unabhängige Profilkopien, profilbezogene Sperre gegen versehentliches Verschieben und Skalieren | Erledigt |

## Empfehlung für das nächste Paket

### Paket 4 – Layout-Schnellsteuerung

**Warum zuerst:** Es ergänzt die vorhandene Layout-Sperre direkt, ist für alle Nutzer sichtbar und greift nur wenig in die empfindliche Fenstererkennung ein.

Geplanter Umfang:

- Layout-Sperre zusätzlich direkt im Tray-Menü ein- und ausschalten.
- Nach dem Speichern von Client- oder Thumbnail-Positionen eine eindeutige Rückmeldung anzeigen.
- Einen sicheren Befehl anbieten, der außerhalb des sichtbaren Desktopbereichs liegende Thumbnails zurückholt.
- Status und Texte vollständig auf Deutsch und Englisch bereitstellen.

Abnahme:

- Tray-Schalter und Einstellung zeigen jederzeit denselben Zustand.
- Bei aktivierter Sperre bleiben Position und Größe unverändert; ein normaler Linksklick aktiviert weiterhin den Client.
- Die Wiederherstellung verändert nur nicht sichtbare Thumbnails und funktioniert mit einem oder mehreren Monitoren.
- Bestehende Konfigurationen starten ohne manuelle Anpassung.

Risiko: niedrig bis mittel. Vor allem die Erkennung des sichtbaren Desktopbereichs muss auf Windows mit unterschiedlichen Monitoranordnungen geprüft werden.

## Weitere wählbare Pakete

Die Reihenfolge ist nicht fest. Abhängigkeiten und Risiko zeigen, welche Pakete sich sinnvoll vorziehen lassen.

| Nr. | Paket | Wesentlicher Nutzen | Voraussetzung | Risiko |
| --- | --- | --- | --- | --- |
| 5 | Positionen komfortabler verwalten | Optionales automatisches Speichern, Zurücksetzen des aktuellen Layouts und verständlichere Statusanzeige | Paket 4 empfohlen | Mittel |
| 6 | Profilverwaltung | Profile umbenennen, duplizieren und sicher löschen; veraltete Clientnamen bereinigen | Keine | Niedrig bis mittel |
| 7 | Zuverlässige Hotkeys und Gruppen | Hängenbleiben oder Überspringen beim Clientwechsel verhindern; Konflikte früh erkennen | Reale Mehrclient-Tests | Mittel bis hoch |
| 8 | Konfigurierbare Mausaktionen | Klicks und Modifier profilbezogen zuordnen; sichere Standardbelegung beibehalten | Paket 3 | Mittel |
| 9 | Erweiterte Thumbnail-Anzeige | Seitenverhältnis sperren, aktive Vorschau ausblenden, drei Always-on-top-Modi | Paket 4 empfohlen | Mittel |
| 10 | Login- und Charakterauswahl | Noch nicht eingeloggte Fenster in Rotation und Positionierung berücksichtigen | Paket 7 empfohlen | Hoch |
| 11 | Multi-Monitor und DPI | Gemischte Skalierungen und Monitorwechsel korrekt behandeln | Paket 4, Testgeräte | Hoch |
| 12 | DWM- und Vorschau-Stabilität | Schwarze Vorschauen und sichtbares Windows-Flackern untersuchen und beheben | Paket 11 empfohlen | Hoch |
| 13 | Konfigurationssicherheit | Atomisches Speichern, Schema-Version, Sicherungen, Wiederherstellung sowie Import/Export | Keine | Mittel |
| 14 | Diagnose und Support | Datenschutzfreundliches Protokoll und exportierbarer Systembericht für reproduzierbare Fehler | Vor Paket 12 empfohlen | Niedrig bis mittel |
| 15 | Release-Härtung | Prüfsummen, In-App-Änderungsübersicht und Bewertung einer optionalen Signierung | Stabile Build-Pipeline | Mittel |
| 16 | Stabile Version `1.1.0` | Gesamttest, kleinere Bedienungs- und Übersetzungsfehler, Abschluss der Preview-Phase | Gewählte Kernpakete | Mittel |

## Paketdetails und Abnahmekriterien

### Paket 5 – Positionen komfortabler verwalten

- Optionales automatisches Speichern getrennt für EVE-Fenster und Thumbnails.
- Aktuelles Profil-Layout gezielt auf Standardwerte zurücksetzen.
- Änderungen der Monitoranordnung erkennen, ohne gültige Positionen unnötig zu überschreiben.
- Abnahme: Manuelles Speichern bleibt verfügbar; automatisches Speichern ist standardmäßig aus; ein Zurücksetzen verlangt Bestätigung.

### Paket 6 – Profilverwaltung

- Profile umbenennen und duplizieren, ohne gemeinsam referenzierte Unterdaten zu erzeugen.
- Löschen mit Bestätigung und Schutz des letzten verbleibenden Profils.
- Nicht mehr verwendete Clientnamen kontrolliert aus Hotkeys und individuellen Farben entfernen.
- Abnahme: Profilwechsel und Neustart erhalten sämtliche Daten; Namen und Profile dürfen nicht unbemerkt verloren gehen.

### Paket 7 – Zuverlässige Hotkeys und Gruppen

- Gruppenwechsel nur über tatsächlich vorhandene EVE-Fenster ausführen.
- Vorwärts- und Rückwärtswechsel gegen Endlosschleifen und verschwundene Fenster absichern.
- Doppelte oder widersprüchliche Hotkeys bereits beim Speichern verständlich melden.
- Namen mit Leerzeichen, Komma und dem Wort „Eve“ als Regressionstests aufnehmen.
- Abnahme: Mehrfaches schnelles Wechseln darf keinen Client überspringen oder den Wechsel dauerhaft blockieren.

Bezug zum Originalprojekt: [#8](https://github.com/g0nzo83/EVE-X-Preview/issues/8), [#12](https://github.com/g0nzo83/EVE-X-Preview/issues/12), [#14](https://github.com/g0nzo83/EVE-X-Preview/issues/14), [#20](https://github.com/g0nzo83/EVE-X-Preview/issues/20) und [#25](https://github.com/g0nzo83/EVE-X-Preview/issues/25).

### Paket 8 – Konfigurierbare Mausaktionen

- Unterstützte Mausgesten pro Profil auswählbar machen.
- „Keine Aktion“ sowie die heutigen Gesten als sichere Vorgaben anbieten.
- Gefährliche Aktionen wie das Schließen eines Clients nur mit ausdrücklicher Aktivierung und Bestätigung zulassen.
- Abnahme: Die Layout-Sperre hat Vorrang vor Verschieben und Skalieren; eine ungültige Belegung kann die Bedienung nicht dauerhaft blockieren.

Bezug zum Originalprojekt: [#28](https://github.com/g0nzo83/EVE-X-Preview/issues/28).

### Paket 9 – Erweiterte Thumbnail-Anzeige

- Optional das Seitenverhältnis beim Skalieren beibehalten.
- Thumbnail des gerade aktiven Clients optional ausblenden.
- Always-on-top als drei Modi: immer, nur bei aktivem EVE-Fenster oder nie.
- Abnahme: Die Regeln funktionieren gemeinsam mit „Bei Fokusverlust ausblenden“, Rahmen und der Layout-Sperre.

Bezug zum Originalprojekt: [#5](https://github.com/g0nzo83/EVE-X-Preview/issues/5), [#7](https://github.com/g0nzo83/EVE-X-Preview/issues/7) und [#16](https://github.com/g0nzo83/EVE-X-Preview/issues/16).

### Paket 10 – Login- und Charakterauswahl

- Fenster ohne bekannten Charakternamen über eine vorläufige, stabile ID verwalten.
- Auswahlfenster in die Hotkey-Rotation aufnehmen.
- Gespeicherte Positionen beim Aus- und erneuten Einloggen erhalten.
- Abnahme: Mehrere Auswahlfenster lassen sich eindeutig wechseln; der Übergang zum Charakternamen erzeugt keinen doppelten oder verlorenen Eintrag.

Bezug zum Originalprojekt: [#6](https://github.com/g0nzo83/EVE-X-Preview/issues/6), [#9](https://github.com/g0nzo83/EVE-X-Preview/issues/9), [#10](https://github.com/g0nzo83/EVE-X-Preview/issues/10), [#18](https://github.com/g0nzo83/EVE-X-Preview/issues/18) und [#21](https://github.com/g0nzo83/EVE-X-Preview/issues/21).

### Paket 11 – Multi-Monitor und DPI

- Koordinaten zwischen logischen und physischen Pixeln konsistent umrechnen.
- Monitorwechsel, unterschiedliche Skalierungen und negative Bildschirmkoordinaten behandeln.
- Positionen validieren und nur bei Bedarf in einen sichtbaren Bereich zurückholen.
- Abnahme: Testmatrix mit Windows 10/11, 100/125/150/200 Prozent und mindestens zwei Monitoranordnungen; bestehende Ein-Monitor-Nutzung bleibt unverändert.

Bezug zum Originalprojekt: [#17](https://github.com/g0nzo83/EVE-X-Preview/issues/17).

### Paket 12 – DWM- und Vorschau-Stabilität

- Zuerst reproduzierbare Diagnose für schwarze Vorschauen und Windows-Flackern ergänzen.
- Lebenszyklus von DWM-Thumbnails und unnötige Fensteraktivierungen überprüfen.
- Korrekturen für GPU-/Treiberunterschiede möglichst isoliert halten.
- Abnahme: Tests auf primärem und sekundärem Monitor, minimiertem Client sowie Fenster- und Vollbildmodus. Ohne reproduzierbares Ergebnis wird keine spekulative Änderung veröffentlicht.

Bezug zum Originalprojekt: [#22](https://github.com/g0nzo83/EVE-X-Preview/issues/22) und [#26](https://github.com/g0nzo83/EVE-X-Preview/issues/26).

### Paket 13 – Konfigurationssicherheit

- JSON zunächst in eine temporäre Datei schreiben und anschließend atomisch ersetzen.
- Schema-Version und kleine, nachvollziehbare Migrationen einführen.
- Zeitlich begrenzte Sicherung vor Migration oder Wiederherstellung anlegen.
- Profile beziehungsweise die gesamte Konfiguration importieren und exportieren.
- Abnahme: Ein abgebrochener Schreibvorgang zerstört die letzte gültige Konfiguration nicht; alte Dateien werden automatisch gelesen; persönliche Daten gelangen nicht in das portable ZIP.

### Paket 14 – Diagnose und Support

- Protokollierung nur nach ausdrücklicher Aktivierung.
- Version, Windows-Version, Monitor-/DPI-Daten und technische Fensterzustände exportieren.
- Charakter- und Profilnamen standardmäßig entfernen oder anonymisieren.
- Abnahme: Der Bericht zeigt vor dem Speichern seinen Inhalt und enthält keine Zugangsdaten oder ungekürzten persönlichen Pfade.

### Paket 15 – Release-Härtung

- SHA-256-Prüfsumme neben jedem portablen ZIP veröffentlichen.
- Änderungen einer neuen Version im Update-Dialog verständlich verlinken.
- Reproduzierbarkeit und Nutzen einer optionalen Code-Signierung prüfen, ohne einen Installer einzuführen.
- Abnahme: Weiterhin genau ein portables ZIP als Programm-Download; Prüfsumme passt zum veröffentlichten Archiv; Updateprüfung bleibt fehlertolerant.

### Paket 16 – Stabile Version `1.1.0`

- Gewählte Kernfunktionen gemeinsam auf Windows 10 und 11 prüfen.
- Deutsche und englische Oberfläche vollständig gegenlesen.
- Bedienungsfehler, abgeschnittene Texte und dokumentierte Regressionstests bereinigen.
- Abnahme: Alle automatischen Prüfungen und die festgelegte manuelle Testmatrix sind grün; bekannte Einschränkungen stehen in den Release Notes.

## Mögliche Entwicklungswege

| Ziel | Sinnvolle Reihenfolge |
| --- | --- |
| Schnelle Bedienungsverbesserungen | 4 → 5 → 6 → 9 |
| Zuverlässiger Clientwechsel | 7 → 10 → 11 → 12 |
| Datensicherheit und Support | 13 → 14 → 15 |
| Kurzer Weg zur stabilen Version | 4 → 7 → 13 → 16 |

## Definition of Done für jedes Paket

Ein Paket gilt erst als fertig, wenn alle zutreffenden Punkte erfüllt sind:

- Umfang und ausdrücklich nicht enthaltene Änderungen sind im Pull Request beschrieben.
- Neue sichtbare Texte existieren auf Deutsch und Englisch; beide Sprachdateien besitzen dieselben Schlüssel.
- Bestehende JSON-Konfigurationen funktionieren weiter oder werden mit Sicherung migriert.
- `python3 scripts/validate_project.py` läuft erfolgreich.
- Der Windows-Workflow kompiliert die AutoHotkey-Anwendung und baut das portable ZIP erfolgreich.
- Neue Kernlogik besitzt passende automatisierte Prüfungen oder dokumentierte manuelle Tests.
- Der Pull Request wird erst nach grünen Prüfungen zusammengeführt.
- Bei einer Programmänderung stimmen `VERSION`, Dateiversion, Release Notes, Tag und ZIP-Name überein.
- Das Release enthält keinen Installer, keine separate EXE und keine persönliche Konfigurationsdatei.

## Auswahl eines Pakets

Für den nächsten Schritt genügt beispielsweise: **„Bitte Paket 4 umsetzen.“** Vor Beginn wird der genaue Umfang noch einmal gegen den aktuellen Code und mögliche Abhängigkeiten geprüft. Wünsche können außerdem als neues Paket aufgenommen oder in ein bestehendes Paket einsortiert werden.

Die detaillierte Auswertung der Meldungen aus dem Originalprojekt steht im [Original-Repo-Backlog](ORIGINAL_REPO_BACKLOG.md).
