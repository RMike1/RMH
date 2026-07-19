# OpenClinic — local Docker

| | Version | Port |
|--|---------|------|
| MySQL | 5.7 | **13306** |
| Tomcat + JDK | 8.5 / 8 | **10088** |

Need: **Docker Desktop** running + SQL backup folder (4 `.sql` files).

---

## First setup

```bash
cd /path/to/this-repo

# 1) Start
docker compose up -d
docker compose ps          # db = healthy

# 2) Import backup (unzip first if .zip) — also sets local URLs + project
./docker/import-backup.sh ~/Downloads/backup_YYYYMMDD_HHMM

# 3) Restart + open
docker compose restart tomcat
```

Open: **http://localhost:10088/openclinic/**  
Logout/login once if you were already logged in.

---

## Every day

| Action | Command |
|--------|---------|
| Start | `docker compose up -d` |
| Stop | `docker compose down` |
| Logs | `docker compose logs -f tomcat` |
| Wipe DB + re-import | `docker compose down -v` → `up -d` → import again → restart tomcat |

---

## Access

| | |
|--|--|
| App | http://localhost:10088/openclinic/ |
| MySQL | `127.0.0.1:13306` — `openclinic` / `openclinic_local` |
| Root | `root` / `root` |

### Enter the database

```bash
# Inside Docker (easiest)
docker exec -it openclinic-db mysql -uroot -proot

# Or from your Mac (if mysql client is installed)
mysql -h 127.0.0.1 -P 13306 -uroot -proot
# mysql -h 127.0.0.1 -P 13306 -uopenclinic -popenclinic_local
```

Useful once inside:

```sql
SHOW DATABASES;
USE openclinic_dbo;
SHOW TABLES;
SELECT oc_key, oc_value FROM oc_config
WHERE oc_key IN ('localcontext','templateSource');
```

GUI (TablePlus / DBeaver / Workbench): host `127.0.0.1`, port `13306`, user `root` / `root`.

---

## Optional

```bash
# one file
./docker/compile-java.sh src/net/admin/User.java
docker compose restart tomcat

# auto-compile on save (leave terminal open)
./docker/watch-java.sh
./docker/watch-java.sh --restart   # + restart Tomcat each time
```

### Java → JSP training test

```bash
docker compose up -d   # both db + tomcat must be running
./docker/compile-java.sh src/training/Hello.java src/training/HelloServlet.java
docker compose restart tomcat
```

Open either:

- http://localhost:10088/openclinic/trainingHello  (servlet → JSP, no OC filters)
- http://localhost:10088/openclinic/test1.jsp     (direct JSP; needs DB up)

Compile targets **Java 8**. Prefer Temurin 8; JDK 11 with `--release 8` also works. Do **not** use JDK 25 for `.class` files Tomcat 8 loads.

Do **not** turn on IDE Java autobuild into `WEB-INF/classes` (it can wipe `be/`).

Apple Silicon: first start is slower.  
`ERROR 1146` in import step 1/4 = normal.
