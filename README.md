# Moodle Dockerized

A simple, ready-to-use Docker environment for Moodle using Apache, PHP, and MySQL. This setup includes an automated entrypoint that handles Moodle installation, configuration through environment variables, and permission management.

## Features

- **PHP 8.4 & Apache**: Built on official PHP images with all required extensions for Moodle.
- **MySQL 8.4**: Pre-configured database service with health checks.
- **Auto-Installation**: Automatically downloads Moodle and configures `config.php` based on your `.env`.

## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Quick Start

1. **Clone the repository:**

```bash
git clone <repository-url>
cd docker-moodle
```

2. **Setup environment variables:**
   Copy the example environment file and adjust values if necessary:

```bash
cp .env.example .env
```

3. **Start the containers:**

```bash
docker compose -f docker-compose-mysql.yml up -d
```

4. **Access Moodle:**
   Open [https://localhost:8080](https://localhost:8080) in your browser.
   _Note: The default configuration enforces HTTPS and maps internal port 80 to 8080._

## Configuration

The following environment variables in your `.env` file control the setup:

### MySQL

> [!NOTE]
> Only needed when running with Docker Compose.

| Variable              | Description                    | Example                    |
| --------------------- | ------------------------------ | -------------------------- |
| `MYSQL_ROOT_PASSWORD` | Root password for MySQL        | `your_mysql_root_password` |
| `MYSQL_DATABASE`      | Name of the database to create | `moodle`                   |
| `MYSQL_USER`          | Database user for Moodle       | `moodle_user`              |
| `MYSQL_PASSWORD`      | Password for the database user | `your_mysql_user_password` |

### Moodle

| Variable           | Description                         | Example                                                        |
| ------------------ | ----------------------------------- | -------------------------------------------------------------- |
| `MOODLE_VERSION`   | Moodle version to download          | `stable501`                                                    |
| `MOODLE_URL`       | Direct download link for Moodle     | `https://packaging.moodle.org/stable501/moodle-latest-501.zip` |
| `MOODLE_WWW_ROOT`  | The public URL of your Moodle site  | `http://example.com`                                           |
| `MOODLE_DATA_ROOT` | Path to moodledata inside container | `/var/www/html/moodledata`                                     |

### Moodle Database

| Variable              | Description                                    | Example              |
| --------------------- | ---------------------------------------------- | -------------------- |
| `MOODLE_DB_TYPE`      | Database driver (mysqli, pgsql, etc.)          | `mysqli`             |
| `MOODLE_DB_HOST`      | Database host (use `mysql` for Docker Compose) | `localhost`          |
| `MOODLE_DB_NAME`      | Database name                                  | `moodle`             |
| `MOODLE_DB_USER`      | Database username                              | `mysql`              |
| `MOODLE_DB_PASS`      | Database password                              | `password`           |
| `MOODLE_DB_PREFIX`    | Database table prefix                          | `mdl_`               |
| `MOODLE_DB_COLLATION` | Database collation                             | `utf8mb4_0900_ai_ci` |

## Persistence

To persist data, you can mount local directories to the container in `docker-compose-mysql.yml`.

- **Moodle Data**: `/var/www/html/moodledata`
- **Activity Modules**: `./src/mod` → `/var/www/html/moodle/public/mod`
- **Blocks**: `./src/blocks` → `/var/www/html/moodle/public/blocks`
- **Themes**: `./src/theme` → `/var/www/html/moodle/public/theme`
- **Local Plugins**: `./src/local` → `/var/www/html/moodle/public/local`
- **Question Types**: `./src/question/type` → `/var/www/html/moodle/public/question/type`

When using Docker Compose:

- **Database**: `/var/lib/mysql`

## Useful Commands

| Action           | Command                                                       |
| ---------------- | ------------------------------------------------------------- |
| Start services   | `docker compose -f docker-compose-mysql.yml up -d`            |
| Stop services    | `docker compose -f docker-compose-mysql.yml stop`             |
| View logs        | `docker compose -f docker-compose-mysql.yml logs -f`          |
| Rebuild image    | `docker compose -f docker-compose-mysql.yml build --no-cache` |
| Reset everything | `docker compose -f docker-compose-mysql.yml down -v`          |
