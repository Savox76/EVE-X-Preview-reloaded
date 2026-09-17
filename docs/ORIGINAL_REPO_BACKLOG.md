# Backlog aus dem Originalprojekt

Stand: 17. September 2026. Quelle: [Issues von g0nzo83/EVE-X-Preview](https://github.com/g0nzo83/EVE-X-Preview/issues).

Die Einträge sind zunächst gemeldete Beobachtungen. Vor einer Übernahme werden Ursache, Reproduzierbarkeit unter Windows 10/11 und mögliche Nebenwirkungen geprüft.

Die daraus abgeleiteten, einzeln wählbaren Entwicklungspakete und ihre Abhängigkeiten stehen im [Entwicklungs-Masterplan](MASTERPLAN.md).

## Bereits in Reloaded berücksichtigt

| Original-Issue | Umsetzung in Reloaded |
| --- | --- |
| [#3 – Clientnamen automatisch eintragen](https://github.com/g0nzo83/EVE-X-Preview/issues/3) | Ab `1.1.0-preview.2` werden tatsächlich geöffnete Charaktere im aktiven Profil automatisch für Hotkeys und individuelle Farben gespeichert. Platzhalter werden entfernt. |
| [#19 – „Eve“ im Charakternamen](https://github.com/g0nzo83/EVE-X-Preview/issues/19) | Die Titelbereinigung ist ab `1.1.0-preview.2` wiederholbar, ohne Namen wie „Eve Valkyrie“ zu verändern. Das dürfte auch einen Teil von #25 beheben. |
| [#4 – Rahmen inaktiver Clients](https://github.com/g0nzo83/EVE-X-Preview/issues/4) | Bereits im bestehenden Funktionsumfang vorhanden; ab `1.1.0-preview.2` zusätzlich über die Farbpalette auswählbar. |
| [#28 – Versehentliches Verschieben](https://github.com/g0nzo83/EVE-X-Preview/issues/28) | Ab `1.1.0-preview.3` lassen sich Position und Größe profilbezogen sperren. Frei belegbare Mausaktionen bleiben als spätere Erweiterung offen. |
| [#14 – Unzuverlässiger Wechsel nach Legion](https://github.com/g0nzo83/EVE-X-Preview/issues/14) und [#20 – Clientwechsel bleibt hängen](https://github.com/g0nzo83/EVE-X-Preview/issues/20) | In `2.0.0` arbeitet der Gruppenwechsel mit einer begrenzten Momentaufnahme vorhandener Fenster. Minimierte Ziele werden wiederhergestellt, ihre Aktivierung wird verifiziert und überholte Minimierungs-Timer werden abgebrochen. |
| [#25 – Charakter wird übersprungen](https://github.com/g0nzo83/EVE-X-Preview/issues/25) | Namen wie „Eve Phillips“ bleiben vollständig erhalten. `2.0.0` prüft diesen Fall zusätzlich mit einem ausführbaren Windows-Regressionstest. |

## Priorität 1 – Fehler untersuchen

| Issue | Beobachtung | Empfohlener nächster Schritt |
| --- | --- | --- |
| [#26 – Windows-Oberfläche flackert](https://github.com/g0nzo83/EVE-X-Preview/issues/26) | Beim Erkennen neuer Clients werden Desktop und andere Fenster sichtbar neu gezeichnet. | DWM-/Thumbnail-Aufrufe und Fensteraktivierung protokollieren; Änderungen isoliert auf Windows 10 und 11 testen. |
| [#22 – Schwarze Vorschau auf zweitem Monitor](https://github.com/g0nzo83/EVE-X-Preview/issues/22) | Vorschauen werden auf einem nicht primären Monitor schwarz; Minimieren beeinflusst das Verhalten. | Multi-Monitor-Testmatrix mit GPU, Vollbild-/Fenstermodus und „Immer im Vordergrund“ erstellen. |
| [#17 – Gemischte 1080p-/4K-DPI-Skalierung](https://github.com/g0nzo83/EVE-X-Preview/issues/17) | Der Bildausschnitt stimmt bei unterschiedlichen DPI-Einstellungen nicht. | DPI-Kontext pro Fenster erfassen und Koordinaten zwischen physischer und logischer Auflösung umrechnen. |
| [#6 – Auswahlbildschirm bleibt sichtbar](https://github.com/g0nzo83/EVE-X-Preview/issues/6) | „Bei Fokusverlust ausblenden“ greift nicht zuverlässig am Charakterauswahlbildschirm. | Auswahlfenster über Handle statt Charaktername verwalten und zusammen mit #21 testen. |

## Priorität 2 – Sinnvolle Verbesserungen

| Issue | Nutzen | Mögliche Umsetzung |
| --- | --- | --- |
| [#28 – Mausgesten konfigurierbar](https://github.com/g0nzo83/EVE-X-Preview/issues/28) | Frei belegbare Aktionen für Klick, Rechtsklick und Modifier. | Aktionszuordnung pro Profil mit sicheren Standardwerten; „Client schließen“ nur mit Bestätigung. |
| [#21 – Auswahlbildschirm in Rotation](https://github.com/g0nzo83/EVE-X-Preview/issues/21) | Wechsel zu noch nicht eingeloggten Accounts. | Stabile temporäre Client-ID pro Fensterhandle; nicht an einen Charakternamen koppeln. |
| [#16 – Seitenverhältnis beibehalten](https://github.com/g0nzo83/EVE-X-Preview/issues/16) | Gleichmäßige Vorschauen beim Skalieren. | Profiloption plus optionaler Shift-Modifier beim Ziehen. |
| [#7 – Aktive Vorschau ausblenden](https://github.com/g0nzo83/EVE-X-Preview/issues/7) | Verhindert das doppelte Bild des aktiven Clients. | Sichtbarkeitsregel mit den bestehenden Fokusverlust- und Rahmenoptionen kombinieren. |
| [#5 – Immer im Vordergrund nur bei EVE](https://github.com/g0nzo83/EVE-X-Preview/issues/5) | Vorschauen stören andere Anwendungen nicht. | Drei Modi: immer, nur bei aktivem EVE, nie. |
| [#24 – Speichern der Positionen verständlicher machen](https://github.com/g0nzo83/EVE-X-Preview/issues/24) | Der vorhandene manuelle Speichervorgang wird leicht übersehen. | Deutliches „Positionen gespeichert“-Feedback oder optional automatisches Speichern. |

## Priorität 3 – Später bewerten

| Issue | Einordnung |
| --- | --- |
| [#15 – Ausschnitt einer Vorschau](https://github.com/g0nzo83/EVE-X-Preview/issues/15) | Interessant für Chat-/UI-Ausschnitte, erfordert aber zusätzliche Zuschneide- und Speicherlogik. |
| [#12 – Weitere Hotkey-Modifier](https://github.com/g0nzo83/EVE-X-Preview/issues/12) | Zuerst Eingabevalidierung und Konflikterkennung verbessern; Kombinationen anschließend gezielt freigeben. |
| [#8 – Leerzeichen oder Komma im Namen](https://github.com/g0nzo83/EVE-X-Preview/issues/8) | Laut Melder später nicht mehr reproduzierbar; als Regressionstest für Sonderzeichen aufnehmen. |
| [#23 – Virenscanner-Meldung](https://github.com/g0nzo83/EVE-X-Preview/issues/23) | Wahrscheinlicher AutoHotkey-Fehlalarm. Reproduzierbare Builds, Prüfsummen und später optional Code-Signing prüfen. |
| [#13 – Andere Anwendungen](https://github.com/g0nzo83/EVE-X-Preview/issues/13) | Bewusste Produktentscheidung: zunächst auf EVE fokussiert bleiben, um Komplexität und Risiken zu begrenzen. |

## Geschlossene Issues als Regressionstests

| Issue | Was bei künftigen Änderungen erhalten bleiben muss |
| --- | --- |
| [#18](https://github.com/g0nzo83/EVE-X-Preview/issues/18) und [#10](https://github.com/g0nzo83/EVE-X-Preview/issues/10) – Position am Auswahlbildschirm | Beim Ausloggen darf eine gespeicherte Vorschauposition nicht unbeabsichtigt verloren gehen. |
| [#9 – Clients am Login-Bildschirm wechseln](https://github.com/g0nzo83/EVE-X-Preview/issues/9) | Zusammen mit #21 erneut prüfen, falls der Auswahlbildschirm erweitert wird. |
| [#2 – Vorschauen verschieben und skalieren](https://github.com/g0nzo83/EVE-X-Preview/issues/2) | Mausinteraktion, Ausrichtung und Größenänderung müssen nach Gesten-/Seitenverhältnis-Änderungen weiter funktionieren. |
| [#1 – Mindestgröße](https://github.com/g0nzo83/EVE-X-Preview/issues/1) | Die konfigurierte Mindestgröße muss beim Erstellen und Skalieren jeder Vorschau gelten. |

## Nicht ungeprüft übernehmen

Der unveröffentlichte Branch `development` des Originals enthält Ansätze für den Charakterauswahlbildschirm und das Abschalten von Live-Vorschauen. Diese Änderungen sollten nicht direkt kopiert werden: Sie verändern zentrale Fenster- und Fehlerbehandlung und benötigen zuerst gezielte Windows-Praxistests.
