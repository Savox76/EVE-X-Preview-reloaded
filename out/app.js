const repo = "Savox76/EVE-X-Preview-reloaded";
const translations = {
  de: {
    skip: "Zum Inhalt springen", menu: "Menü", homeLabel: "EVE-X-Preview Reloaded Startseite", navLabel: "Hauptnavigation", previewLabel: "Vorschau der Anwendung", navFeatures: "Funktionen", navSetup: "Anleitung", navUpdates: "Neuigkeiten", navRoadmap: "Roadmap", navSupport: "Support",
    eyebrow: "PORTABLE · WINDOWS · DE / EN", heroTitle: "Alle EVE-Clients.<br><span>Ein klarer Überblick.</span>", heroLead: "Behalte mehrere EVE-Online-Fenster als Live-Thumbnails im Blick und wechsle per Klick oder Hotkey sofort zum richtigen Charakter.", download: "Portable Version laden", quickStart: "Schnellstart ansehen", currentVersion: "Aktueller Stand", noInstaller: "Kein Installer",
    clientsOnline: "4 Clients aktiv", layoutLocked: "Layout gesperrt", active: "AKTIV", hotkeysReady: "Hotkeys bereit", profileLabel: "Profil: Flotte",
    portable: "Portable", portableSub: "Entpacken und starten", eulaAware: "EULA-bewusst", eulaSub: "Kein Input Broadcasting", local: "Lokal", localSub: "Einstellungen bleiben bei dir", openSource: "Open Source",
    featuresKicker: "FUNKTIONEN", featuresTitle: "Für mehrere Clients gebaut.<br><span>Ohne Umwege.</span>", featuresLead: "Alles Wichtige für einen schnellen, kontrollierten Wechsel zwischen deinen aktiven EVE-Fenstern.",
    f1Title: "Live-Thumbnails", f1Text: "Alle laufenden EVE-Clients als frei positionierbare Vorschauen – inklusive Name, Rahmen und eigener Größe.", f2Title: "Sofortiger Wechsel", f2Text: "Ein Klick oder frei gewählter Tastatur- und Maus-Hotkey bringt den gewünschten Client nach vorn.", f3Title: "Flexible Profile", f3Text: "Getrennte Anordnungen, Hotkeys und Farben für Mining, Produktion, Flotte oder jeden anderen Einsatz.", f4Title: "Farben mit System", f4Text: "Windows-Farbpalette, HEX- und RGB-Eingabe für Text, aktive Clients und individuelle Charakterrahmen.", f5Title: "Layout-Schutz", f5Text: "Sperre Position und Größe pro Profil, damit ein versehentlicher Rechtsklick dein Layout nicht verschiebt.", f6Title: "Deutsch & Englisch", f6Text: "Umschaltbare Oberfläche und automatische Hinweise, sobald eine neue GitHub-Version verfügbar ist.",
    setupKicker: "SCHNELLSTART", setupTitle: "In vier Schritten<br><span>einsatzbereit.</span>", s1Title: "ZIP herunterladen", s1Text: "Öffne die GitHub-Releases und lade das aktuelle portable ZIP.", s2Title: "Komplett entpacken", s2Text: "Lege den vollständigen Ordner an einem beschreibbaren Ort ab, zum Beispiel unter Dokumente.", s3Title: "EXE starten", s3Text: "Starte EVE-X-Preview-Reloaded.exe. Deine Einstellungen werden direkt im Programmordner gespeichert.", s4Title: "Profil anlegen", s4Text: "Öffne das Tray-Menü, erstelle ein Profil und ordne Thumbnails sowie Hotkeys nach Wunsch an.", setupNotice: "<strong>Wichtig:</strong> Behalte den Ordner <code>locales</code> neben der EXE. Aktualisierungen ersetzen deine persönliche <code>EVE-X-Preview.json</code> nicht.", fullGuide: "Vollständige Anleitung öffnen",
    updatesKicker: "NEUIGKEITEN", updatesTitle: "Der aktuelle<br><span>Release-Stand.</span>", updatesLead: "Version und Änderungen werden direkt aus GitHub geladen und bleiben dadurch automatisch aktuell.", latestRelease: "NEUESTER RELEASE", loadingRelease: "Release wird geladen …", releaseFallback1: "Portable Nutzung ohne Installer", releaseFallback2: "Deutsche und englische Oberfläche", releaseFallback3: "Automatische Update-Hinweise", allReleaseNotes: "Alle Release-Details",
    roadmapKicker: "ROADMAP", roadmapTitle: "Was als Nächstes<br><span>möglich ist.</span>", roadmapLead: "Die Planung ist transparent. Pakete starten erst nach einer bewussten Entscheidung und werden nur nach erfolgreichen Prüfungen veröffentlicht.", recommendedNext: "EMPFOHLENES NÄCHSTES PAKET", p4Title: "Layout-Schnellsteuerung", p4Text: "Direkte Layout-Sperre im Tray, klare Rückmeldungen beim Speichern und sicheres Zurückholen nicht sichtbarer Thumbnails.", risk: "Risiko", lowMedium: "Niedrig bis mittel", road1Title: "Layout & Profile", road1Text: "Positionen komfortabler verwalten, Profile duplizieren, umbenennen und bereinigen.", road2Title: "Steuerung & Anzeige", road2Text: "Zuverlässigere Hotkeys, konfigurierbare Mausaktionen und erweiterte Thumbnail-Modi.", road3Title: "Stabilität & Support", road3Text: "Multi-Monitor/DPI, DWM-Stabilität, sichere Konfigurationen und Diagnoseberichte.", road4Title: "Release-Härtung", road4Text: "Prüfsummen, bessere Änderungsübersicht und Abschluss der Preview-Phase.", roadmapSync: "Der vollständige Masterplan wird im Repository gepflegt.", openMasterplan: "Masterplan öffnen",
    supportKicker: "FEEDBACK & SUPPORT", supportTitle: "Fehler gefunden?<br><span>Idee an Bord?</span>", supportLead: "Nutze die vorbereiteten GitHub-Formulare. Je genauer die Angaben sind, desto schneller lässt sich ein Problem nachvollziehen oder eine Idee bewerten.", bugLabel: "FEHLER MELDEN", bugTitle: "Bug-Report erstellen", bugText: "Version, Windows-Stand und genaue Schritte erfassen.", ideaLabel: "VERBESSERUNG", ideaTitle: "Vorschlag einreichen", ideaText: "Nutzen, Wunschverhalten und mögliche Alternativen beschreiben.", viewIssues: "Offene Issues ansehen", footerTagline: "Multi-Client-Übersicht für EVE Online.", legal: "EVE Online und alle zugehörigen Logos sind Eigentum von CCP hf. Dieses unabhängige Projekt ist nicht mit CCP hf verbunden. Nutzung auf eigene Verantwortung.",
    releaseUnavailable: "Release-Informationen auf GitHub ansehen", roadmapOnline: "Masterplan ist mit GitHub verbunden."
  },
  en: {
    skip: "Skip to content", menu: "Menu", homeLabel: "EVE-X-Preview Reloaded home", navLabel: "Main navigation", previewLabel: "Application preview", navFeatures: "Features", navSetup: "Guide", navUpdates: "What's new", navRoadmap: "Roadmap", navSupport: "Support",
    eyebrow: "PORTABLE · WINDOWS · DE / EN", heroTitle: "Every EVE client.<br><span>One clear view.</span>", heroLead: "Keep multiple EVE Online windows visible as live thumbnails and switch to the right character instantly by click or hotkey.", download: "Download portable version", quickStart: "View quick start", currentVersion: "Current version", noInstaller: "No installer",
    clientsOnline: "4 clients active", layoutLocked: "Layout locked", active: "ACTIVE", hotkeysReady: "Hotkeys ready", profileLabel: "Profile: Fleet",
    portable: "Portable", portableSub: "Extract and run", eulaAware: "EULA-aware", eulaSub: "No input broadcasting", local: "Local", localSub: "Your settings stay with you", openSource: "Open source",
    featuresKicker: "FEATURES", featuresTitle: "Built for many clients.<br><span>Without the clutter.</span>", featuresLead: "Everything needed for fast, controlled switching between your active EVE windows.",
    f1Title: "Live thumbnails", f1Text: "Every running EVE client as a freely positioned preview, including character name, border and custom size.", f2Title: "Instant switching", f2Text: "One click or a freely chosen keyboard or mouse hotkey brings the intended client to the front.", f3Title: "Flexible profiles", f3Text: "Separate layouts, hotkeys and colors for mining, industry, fleets or any other activity.", f4Title: "Color control", f4Text: "Windows color palette plus HEX and RGB entry for text, active clients and character-specific borders.", f5Title: "Layout protection", f5Text: "Lock position and size per profile so an accidental right-click cannot move your layout.", f6Title: "German & English", f6Text: "A switchable interface and automatic notices whenever a newer GitHub version is available.",
    setupKicker: "QUICK START", setupTitle: "Ready in<br><span>four steps.</span>", s1Title: "Download the ZIP", s1Text: "Open GitHub Releases and download the current portable ZIP.", s2Title: "Extract everything", s2Text: "Place the complete folder in a writable location such as Documents.", s3Title: "Launch the EXE", s3Text: "Run EVE-X-Preview-Reloaded.exe. Your settings are stored directly beside the application.", s4Title: "Create a profile", s4Text: "Open the tray menu, create a profile and arrange thumbnails and hotkeys as needed.", setupNotice: "<strong>Important:</strong> Keep the <code>locales</code> folder beside the EXE. Updates do not replace your personal <code>EVE-X-Preview.json</code>.", fullGuide: "Open the complete guide",
    updatesKicker: "WHAT'S NEW", updatesTitle: "The latest<br><span>release status.</span>", updatesLead: "Version and changes are loaded directly from GitHub, so the information stays current automatically.", latestRelease: "LATEST RELEASE", loadingRelease: "Loading release …", releaseFallback1: "Portable use without an installer", releaseFallback2: "German and English interface", releaseFallback3: "Automatic update notices", allReleaseNotes: "All release details",
    roadmapKicker: "ROADMAP", roadmapTitle: "What could<br><span>come next.</span>", roadmapLead: "Planning is transparent. Packages only start after a deliberate decision and are published only after successful checks.", recommendedNext: "RECOMMENDED NEXT PACKAGE", p4Title: "Quick layout controls", p4Text: "Direct tray access to the layout lock, clear save confirmations and a safe way to recover off-screen thumbnails.", risk: "Risk", lowMedium: "Low to medium", road1Title: "Layouts & profiles", road1Text: "Manage positions more easily; duplicate, rename and clean up profiles.", road2Title: "Controls & display", road2Text: "More reliable hotkeys, configurable mouse actions and advanced thumbnail modes.", road3Title: "Stability & support", road3Text: "Multi-monitor/DPI support, DWM stability, safer configuration and diagnostic reports.", road4Title: "Release hardening", road4Text: "Checksums, better change overviews and completion of the preview phase.", roadmapSync: "The full development plan is maintained in the repository.", openMasterplan: "Open master plan",
    supportKicker: "FEEDBACK & SUPPORT", supportTitle: "Found a bug?<br><span>Have an idea?</span>", supportLead: "Use the prepared GitHub forms. Precise details help reproduce a problem or assess an idea much faster.", bugLabel: "REPORT A PROBLEM", bugTitle: "Create bug report", bugText: "Capture the version, Windows build and exact reproduction steps.", ideaLabel: "IMPROVEMENT", ideaTitle: "Submit suggestion", ideaText: "Describe the benefit, desired behavior and possible alternatives.", viewIssues: "View open issues", footerTagline: "Multi-client overview for EVE Online.", legal: "EVE Online and all related logos are the property of CCP hf. This independent project is not affiliated with CCP hf. Use at your own risk.",
    releaseUnavailable: "View release information on GitHub", roadmapOnline: "The master plan is connected to GitHub."
  }
};

let language = localStorage.getItem("eve-x-site-language") || (navigator.language.toLowerCase().startsWith("de") ? "de" : "en");

function applyLanguage(nextLanguage) {
  language = nextLanguage in translations ? nextLanguage : "de";
  const strings = translations[language];
  document.documentElement.lang = language;
  document.querySelectorAll("[data-i18n]").forEach((element) => {
    const value = strings[element.dataset.i18n];
    if (value) element.textContent = value;
  });
  document.querySelectorAll("[data-i18n-html]").forEach((element) => {
    const value = strings[element.dataset.i18nHtml];
    if (value) element.innerHTML = value;
  });
  document.querySelectorAll("[data-i18n-aria]").forEach((element) => {
    const value = strings[element.dataset.i18nAria];
    if (value) element.setAttribute("aria-label", value);
  });
  const switcher = document.querySelector(".language-switch");
  switcher.innerHTML = language === "de"
    ? '<span class="language-active">DE</span><span aria-hidden="true">/</span><span>EN</span>'
    : '<span>DE</span><span aria-hidden="true">/</span><span class="language-active">EN</span>';
  switcher.setAttribute("aria-label", language === "de" ? "Switch language to English" : "Sprache auf Deutsch wechseln");
  localStorage.setItem("eve-x-site-language", language);
  updateRelease(window.latestRelease);
}

function cleanReleaseLine(value) {
  return value
    .replace(/^[-*]\s+/, "")
    .replace(/`([^`]+)`/g, "$1")
    .replace(/\[([^\]]+)\]\([^)]+\)/g, "$1")
    .replace(/[*_#>]/g, "")
    .trim();
}

function releaseHighlights(body) {
  const bulletLines = String(body || "")
    .split("\n")
    .filter((line) => /^\s*[-*]\s+/.test(line))
    .map(cleanReleaseLine)
    .filter(Boolean);
  return [...new Set(bulletLines)].slice(0, 5);
}

function updateRelease(release) {
  if (!release) return;
  const strings = translations[language];
  const title = document.getElementById("release-title");
  const date = document.getElementById("release-date");
  const notes = document.getElementById("release-notes");
  const version = document.getElementById("hero-version");
  const releaseLink = document.getElementById("release-link");
  const notesLink = document.getElementById("release-notes-link");
  title.textContent = release.name || release.tag_name || strings.releaseUnavailable;
  version.textContent = release.tag_name || "GitHub Release";
  date.textContent = release.published_at
    ? new Intl.DateTimeFormat(language === "de" ? "de-DE" : "en-GB", { dateStyle: "medium" }).format(new Date(release.published_at))
    : "GitHub";
  if (release.html_url) {
    releaseLink.href = release.html_url;
    notesLink.href = release.html_url;
  }
  const highlights = releaseHighlights(release.body);
  if (highlights.length) {
    notes.replaceChildren(...highlights.map((line) => {
      const item = document.createElement("li");
      item.textContent = line;
      return item;
    }));
  }
}

async function loadRelease() {
  try {
    const response = await fetch(`https://api.github.com/repos/${repo}/releases?per_page=1`, { headers: { Accept: "application/vnd.github+json" } });
    if (!response.ok) throw new Error("Release API unavailable");
    const releases = await response.json();
    window.latestRelease = releases[0] || null;
    if (window.latestRelease) updateRelease(window.latestRelease);
  } catch (_) {
    document.getElementById("release-title").textContent = translations[language].releaseUnavailable;
  }
}

async function loadRoadmapStatus() {
  try {
    const response = await fetch(`https://raw.githubusercontent.com/${repo}/main/docs/MASTERPLAN.md`);
    if (!response.ok) throw new Error("Master plan unavailable");
    const markdown = await response.text();
    const match = markdown.match(/## Empfehlung[^\n]*\n[\s\S]*?###\s+Paket\s+(\d+)\s+[–-]\s+([^\n]+)/i);
    if (match) {
      document.querySelector(".package-number").textContent = String(match[1]).padStart(2, "0");
      if (language === "de") document.getElementById("next-package-title").textContent = match[2].trim();
    }
    const status = document.getElementById("roadmap-status");
    status.classList.add("online");
    status.title = translations[language].roadmapOnline;
  } catch (_) {
    // The static roadmap remains available when GitHub cannot be reached.
  }
}

document.querySelector(".language-switch").addEventListener("click", () => applyLanguage(language === "de" ? "en" : "de"));
const menuToggle = document.querySelector(".menu-toggle");
const nav = document.getElementById("main-nav");
menuToggle.addEventListener("click", () => {
  const open = nav.classList.toggle("open");
  menuToggle.setAttribute("aria-expanded", String(open));
});
nav.querySelectorAll("a").forEach((link) => link.addEventListener("click", () => {
  nav.classList.remove("open");
  menuToggle.setAttribute("aria-expanded", "false");
}));

applyLanguage(language);
loadRelease();
loadRoadmapStatus();
