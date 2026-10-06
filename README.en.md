# LimeSurvey Docker Setup

This project provides a Docker-based setup for **LimeSurvey**. It uses a custom Apache/PHP image alongside a MariaDB database managed via Docker Compose.

## 📋 File Structure

Ensure your project structure looks as follows:

```
.
├── Dockerfile          # Definition of the LimeSurvey Apache/PHP image
├── custom.ini          # Custom PHP configurations
├── docker-compose.yml  # Multi-container orchestration (LimeSurvey + MariaDB)
└── README.md           # Project documentation
```

## ⚙️️ Prerequisites

* [Docker Engine](https://docs.docker.com/get-docker/) installed and running
* [Docker Compose](https://docs.docker.com/compose/install/) (included by default in modern Docker Desktop installations)

## 🔧 PHP Configuration (`custom.ini`)

The `custom.ini` file customizes PHP parameters to meet the requirements of LimeSurvey (e.g., for larger surveys or file uploads):

```ini
max_input_vars = 5000
post_max_size = 32M
upload_max_filesize = 32M
```

## 🚀 Step-by-Step Guide

### 1. Security Note (Change Passwords)

Before starting the containers, make sure to change the default database passwords in `docker-compose.yml`:

```yaml
# In docker-compose.yml:
MYSQL_ROOT_PASSWORD: your_secure_root_password
MYSQL_PASSWORD: your_secure_db_password
DB_PASSWORD: your_secure_db_password # Must match MYSQL_PASSWORD
```

### 2. Build the Docker Image

Build the custom LimeSurvey Docker image based on the `Dockerfile`:

```bash
docker build -t limesurvey:latest .
```

*Note: This step downloads the PHP 8.2 Apache base image, copies `custom.ini`, installs required PHP extensions (e.g., `gd`, `pdo_mysql`, `intl`, `imap`), and downloads the latest LimeSurvey version.*

### 3. Start the Containers

Once the image is built, start LimeSurvey and the MariaDB database in the background using Docker Compose:

```bash
docker compose up -d
```

*(For older Docker installations, the command might be `docker-compose up -d`)*

### 4. Access the Application & Complete Setup

1. Open your web browser and navigate to:

   ```
   http://localhost:8080
   ```

2. Follow the graphical setup wizard for LimeSurvey.

3. Use the following values during the database configuration step:

   * **Database type:** `MySQL / MariaDB`
   * **Database host:** `db`
   * **Database name:** `limesurvey`
   * **Username:** `limesurvey_user`
   * **Password:** *(The password defined in docker-compose.yml)*

## 🛠️ Useful Commands

| Action | Command |
| :--- | :--- |
| **Check container status** | `docker compose ps` |
| **View live logs** | `docker compose logs -f` |
| **Stop containers** | `docker compose stop` |
| **Stop & remove containers** | `docker compose down` |
| **Rebuild image & restart containers** | `docker compose up -d --build` |

## 💾 Data Persistence (Volumes)

The following named volumes ensure your data persists across container restarts or teardowns:

* `db_data`: Stores MariaDB database files.
* `limesurvey_data`: Stores uploaded files and web application configurations.