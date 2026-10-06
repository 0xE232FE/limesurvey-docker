# LimeSurvey Docker Setup

Dieses Projekt stellt ein Docker-basiertes Setup für **LimeSurvey** zur Verfügung. Es nutzt ein benutzerdefiniertes Apache/PHP-Image zusammen mit einer MariaDB-Datenbank über Docker Compose.

## 📋 Dateistruktur

Stelle sicher, dass deine Projektstruktur folgendermaßen aussieht:

```
.
├── Dockerfile          # Definition des LimeSurvey Apache/PHP Images
├── custom.ini          # Individuelle PHP-Konfigurationen
├── docker-compose.yml  # Multi-Container-Orchestrierung (LimeSurvey + MariaDB)
└── README.md           # Projektdokumentation

```

## ⚙️ Voraussetzungen

* [Docker Engine](https://docs.docker.com/get-docker/) installierten und laufend

* [Docker Compose](https://docs.docker.com/compose/install/) (ist in modernen Docker Desktop Installationen bereits enthalten)

## 🔧 PHP-Konfiguration (`custom.ini`)

In der `custom.ini` werden Werte für PHP angepasst, um den Anforderungen von LimeSurvey zu entsprechen (z. B. für größere Umfragen oder Uploads):

```
max_input_vars = 5000
post_max_size = 32M
upload_max_filesize = 32M

```

## 🚀 Schritt-für-Schritt Anleitung

### 1. Sicherheitshinweis (Passwörter anpassen)

Bevor du die Container startest, passe unbedingt die Datenbank-Passwörter in der `docker-compose.yml` an:

```
# In docker-compose.yml:
MYSQL_ROOT_PASSWORD: dein_sicheres_root_passwort
MYSQL_PASSWORD: dein_sicheres_db_passwort
DB_PASSWORD: dein_sicheres_db_passwort # Muss mit MYSQL_PASSWORD übereinstimmen

```

### 2. Docker Image bauen

Erstelle das LimeSurvey Docker Image manuell basierend auf dem `Dockerfile`:

```
docker build -t limesurvey:latest .

```

*Hinweis: Dieser Schritt lädt das PHP 8.2 Apache Basis-Image herunter, kopiert die `custom.ini`, installiert erforderliche PHP-Erweiterungen (u.a. `gd`, `pdo_mysql`, `intl`, `imap`) und lädt die neueste LimeSurvey-Version herunter.*

### 3. Container starten

Nachdem das Image gebaut wurde, kannst du LimeSurvey und die MariaDB-Datenbank mit Docker Compose im Hintergrund starten:

```
docker compose up -d

```

*(Bei älteren Docker-Installationen lautet der Befehl eventuell `docker-compose up -d`)*

### 4. Anwendung aufrufen & Installation abschließen

1. Öffne deinen Webbrowser und rufe die Adresse auf:

   ```
   http://localhost:8080
   
   ```

2. Folge dem grafischen Installations-Assistenten von LimeSurvey.

3. Verwende bei der Datenbank-Konfiguration im Setup folgende Werte:

   * **Datenbanktyp:** `MySQL / MariaDB`

   * **Datenbank-Host:** `db`

   * **Datenbankname:** `limesurvey`

   * **Benutzername:** `limesurvey_user`

   * **Passwort:** *(Das in der docker-compose.yml festgelegte Passwort)*

## 🛠️ Nützliche Befehle

| **Aktion** | **Befehl** | 
| **Status der Container prüfen** | `docker compose ps` | 
| **Logs anzeigen (live)** | `docker compose logs -f` | 
| **Container stoppen** | `docker compose stop` | 
| **Container stoppen & entfernen** | `docker compose down` | 
| **Image neu bauen & Container neu starten** | `docker compose up -d --build` | 

## 💾 Datenpersistenz (Volumes)

Die folgenden Named Volumes sorgen dafür, dass deine Daten auch beim Neustart oder Stoppen der Container erhalten bleiben:

* `db_data`: Speichert die MariaDB-Datenbankdaten.

* `limesurvey_data`: Speichert hochgeladene Dateien und Konfigurationen der Webanwendung.
