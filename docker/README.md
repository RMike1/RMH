# OC Installation Guide


|              | Version | Port      |
| ------------ | ------- | --------- |
| MySQL        | 5.7     | **13306** |
| Tomcat + JDK | 8.5 / 8 | **10088** |


Need: **Docker Desktop** running + SQL backup folder (4 `.sql` files).

---

## First setup

```bash
cd /path/to/this-repo

# 1) Start
docker compose up -d
docker compose ps         

# 2) Import dumps
./docker/import-backup.sh ~/Downloads/backup_YYYYMMDD_HHMM

# 3) Restart + open
docker compose restart tomcat
```

Open: **[http://localhost:10088/openclinic/](http://localhost:10088/openclinic/)**  
Logout/login once if you were already logged in.

---



## Every day


| Action              | Command                                                            |
| ------------------- | ------------------------------------------------------------------ |
| Start               | `docker compose up -d`                                             |
| Stop                | `docker compose down`                                              |
| Logs                | `docker compose logs -f tomcat`                                    |
| Wipe DB + re-import | `docker compose down -v` → `up -d` → import again → restart tomcat |


---



## Access


|       |                                                                          |
| ----- | ------------------------------------------------------------------------ |
| App   | [http://localhost:10088/openclinic/](http://localhost:10088/openclinic/) |
| MySQL | `127.0.0.1:13306` — `openclinic` / `openclinic_local`                    |
| Root  | `root` / `root`                                                          |




### Enter the database

```bash
# Inside Docker (easiest)
docker exec -it openclinic-db mysql -uroot -proot

# Or from your Mac (if mysql client is installed)
mysql -h 127.0.0.1 -P 13306 -uroot -proot
# mysql -h 127.0.0.1 -P 13306 -uopenclinic -popenclinic_local
```



---



## Optional

### Compile Java 
```bash
./docker/compile-java.sh src/net/admin/User.java
docker compose restart tomcat

./docker/watch-java.sh            # auto-compile on save
./docker/watch-java.sh --restart  # + restart Tomcat each time
```
