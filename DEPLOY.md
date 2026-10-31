# FridgeChef: AWS Deployment Guide

FridgeChef is a Flask (Python) + MySQL web app with 5 modules: **Authentication**, **My Fridge** (inventory with expiry tracking), **Recipes** (CRUD + search), **Cook Match** (ranks recipes by ingredients you have) and **Favorites & Shopping List**.

| Part | Model | Services | URL looks like |
|---|---|---|---|
| I | IaaS | EC2 (Ubuntu) + MySQL on the same VM | `http://<EC2-public-IP>` |
| II | PaaS | S3 (code) + Elastic Beanstalk (app) + RDS (MySQL) | `http://fridgechef-env.xxxx.<region>.elasticbeanstalk.com` |

`/health` on either URL returns JSON showing the database connection. Screenshot it for the report.

> 📸 = take a screenshot for the report at this step.

---

## Project files

```
application.py        Flask app (WSGI callable = "application")
schema.sql            6 tables: users, pantry_items, recipes, recipe_ingredients, favorites, shopping_list
seed.sql              12 sample recipes
readonly_user.sql     read-only "evaluator" account for the grading script
requirements.txt      Flask, PyMySQL, cryptography, gunicorn
Procfile              how Elastic Beanstalk starts the app (gunicorn on port 8000)
.env.example          database settings template
deploy/               systemd + nginx config used on EC2
templates/, static/   HTML + CSS
```

The app reads its database settings from environment variables: `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `SECRET_KEY`.

**Before you start:** pick your own passwords now and use them everywhere below instead of the examples.
- App DB user password (example `FridgeApp@2026`)
- Read-only evaluator password (example `Eval@12345`, set in `readonly_user.sql`)
- RDS master password (example `RdsAdmin2026`)

---

# PART I: IaaS deployment on Amazon EC2

## 1. Launch an Ubuntu EC2 instance
1. AWS Console → **EC2** → **Launch instance**. 📸
2. **Name:** `fridgechef-ec2`.
3. **AMI:** *Ubuntu Server 24.04 LTS* (Free tier eligible).
4. **Instance type:** `t2.micro` or `t3.micro`.
5. **Key pair:** **Create new key pair**, name `fridgechef-key`, type RSA, format `.pem`. It downloads automatically, so keep it safe. 📸
6. Keep the default storage (8 GB). Then do step 2 in the same screen.

## 2. Security group rules
Under **Network settings → Edit**, create security group `fridgechef-ec2-sg` with these inbound rules: 📸

| Type | Port | Source | Why |
|---|---|---|---|
| SSH | 22 | My IP | terminal access |
| HTTP | 80 | Anywhere (0.0.0.0/0) | the website |
| MySQL/Aurora | 3306 | Anywhere (0.0.0.0/0) | lets the grading script verify the database |

Click **Launch instance**. Then open the instance and copy its **Public IPv4 address**. 📸

## 3. Connect with SSH
Run this on your computer (Windows PowerShell has `ssh` built in), from the folder containing the key:

```bash
# macOS / Linux
chmod 400 fridgechef-key.pem
# Windows PowerShell (restrict the key so ssh accepts it)
icacls fridgechef-key.pem /inheritance:r /grant:r "$($env:USERNAME):(R)"

ssh -i fridgechef-key.pem ubuntu@<EC2-PUBLIC-IP>
```
Type `yes` at the fingerprint prompt. 📸 (the Ubuntu welcome banner)

## 4. Install the servers with the package manager
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3-venv python3-pip nginx mysql-server unzip
sudo systemctl enable --now mysql nginx
systemctl status mysql nginx --no-pager      # both should be "active (running)"  📸
```

## 5. Upload the application code
From **your computer** (a new terminal, not the SSH one):
```bash
scp -i fridgechef-key.pem fridgechef-ec2.zip ubuntu@<EC2-PUBLIC-IP>:~
```
Back in the **SSH session**:
```bash
cd ~ && unzip fridgechef-ec2.zip -d fridgechef && ls fridgechef     📸
```
(Alternative: push the code to GitHub and run `git clone <repo> fridgechef`.)

## 6. Create the database, app user and schema
```bash
sudo mysql <<'SQL'
CREATE DATABASE fridgechef CHARACTER SET utf8mb4;
CREATE USER 'fridgechef'@'localhost' IDENTIFIED BY 'FridgeApp@2026';
GRANT ALL PRIVILEGES ON fridgechef.* TO 'fridgechef'@'localhost';
FLUSH PRIVILEGES;
SQL

cd ~/fridgechef
mysql -u fridgechef -p fridgechef < schema.sql      # enter FridgeApp@2026
mysql -u fridgechef -p fridgechef < seed.sql
mysql -u fridgechef -p fridgechef -e "SHOW TABLES; SELECT COUNT(*) FROM recipes;"    📸
```

## 7. Read-only account + remote access (for the grader)
```bash
nano readonly_user.sql            # change the password if you want
sudo mysql < readonly_user.sql

# Let MySQL accept connections from outside the VM
sudo sed -i 's/^bind-address.*/bind-address = 0.0.0.0/; s/^mysqlx-bind-address.*/mysqlx-bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql

# Prove the evaluator can read but not write
mysql -u evaluator -p -h 127.0.0.1 fridgechef -e "SELECT COUNT(*) FROM recipes;"
mysql -u evaluator -p -h 127.0.0.1 fridgechef -e "DELETE FROM recipes;"   # must fail: DELETE command denied  📸
```

## 8. Python environment and configuration
```bash
cd ~/fridgechef
python3 -m venv venv
venv/bin/pip install -r requirements.txt
cp .env.example .env
nano .env        # DB_PASSWORD=FridgeApp@2026, and set SECRET_KEY to any long random text
```

## 9. Configure the permissions
```bash
sudo chown -R ubuntu:www-data /home/ubuntu/fridgechef
sudo chmod 755 /home/ubuntu                       # nginx (www-data) must be able to traverse the home dir
find ~/fridgechef -type d -exec chmod 750 {} \;
find ~/fridgechef -type f -exec chmod 640 {} \;
chmod -R u+x ~/fridgechef/venv/bin
chmod 600 ~/fridgechef/.env                      # secrets readable only by ubuntu
ls -la ~/fridgechef                                📸
```

## 10. Run the app as a service (gunicorn + systemd)
```bash
sudo cp deploy/fridgechef.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now fridgechef
systemctl status fridgechef --no-pager            # active (running)  📸
curl http://127.0.0.1:8000/health                 # {"status":"ok","database":"connected",...}
```

## 11. Put Nginx in front (port 80)
```bash
sudo cp deploy/nginx-fridgechef.conf /etc/nginx/sites-available/fridgechef
sudo ln -sf /etc/nginx/sites-available/fridgechef /etc/nginx/sites-enabled/fridgechef
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl reload nginx
```

## 12. Test in the browser
Open `http://<EC2-PUBLIC-IP>` 📸. Then:
- Sign up, add a few ingredients in **My Fridge**, open **Cook Match**, save a favorite, and add missing items to the **Shopping list**. 📸 each page.
- Open `http://<EC2-PUBLIC-IP>/health`. 📸

**Part I form details:**
URL `http://<EC2-PUBLIC-IP>` · DB host `<EC2-PUBLIC-IP>` · port `3306` · database `fridgechef` · user `evaluator` · password (yours).

> Stopping and restarting the instance changes its public IP. To keep a fixed IP, allocate an **Elastic IP** (EC2 → Elastic IPs → Allocate → Associate with the instance).

---

# PART II: PaaS deployment (S3 + Elastic Beanstalk + RDS)

## 1. Create the RDS MySQL database
1. AWS Console → **RDS** → **Create database**. 📸
2. **Standard create** → **MySQL** → template **Free tier**.
3. **DB instance identifier:** `fridgechef-db`. **Master username:** `admin`. **Master password:** `RdsAdmin2026` (yours).
4. **Instance class:** `db.t3.micro` (or `db.t4g.micro`). **Storage:** 20 GB.
5. **Connectivity:** Public access **Yes** (so the grader can connect). VPC security group **Create new** → `fridgechef-rds-sg`.
6. **Additional configuration → Initial database name:** `fridgechef` (don't skip this).
7. **Create database**. It takes about 5–10 minutes. Copy the **Endpoint** (e.g. `fridgechef-db.abc123.us-east-1.rds.amazonaws.com`). 📸
8. **EC2 → Security Groups → `fridgechef-rds-sg` → Edit inbound rules:** add MySQL/Aurora 3306 from Anywhere (0.0.0.0/0). 📸

## 2. Load the schema into RDS and create the read-only user
The easiest place to run this is your Part I EC2 instance (the `mysql` client is already installed):
```bash
cd ~/fridgechef
RDS=fridgechef-db.abc123.us-east-1.rds.amazonaws.com      # your endpoint
mysql -h $RDS -u admin -p fridgechef < schema.sql
mysql -h $RDS -u admin -p fridgechef < seed.sql
mysql -h $RDS -u admin -p < readonly_user.sql
mysql -h $RDS -u evaluator -p fridgechef -e "SELECT COUNT(*) FROM recipes;"      📸
```

## 3. Upload the application bundle to S3
1. Use **`fridgechef-eb.zip`**. `application.py`, `Procfile` and `requirements.txt` must sit at the **root of the zip**, not inside a folder. The provided zip is already built this way.
2. **S3 → Create bucket** → name `fridgechef-code-<yourname>` (names are global), same region as everything else → Create. 📸
3. Open the bucket → **Upload** → `fridgechef-eb.zip` → Upload. 📸
4. Click the object and copy its **Object URL** (`https://fridgechef-code-xxx.s3.<region>.amazonaws.com/fridgechef-eb.zip`).

## 4. Create the Elastic Beanstalk environment
1. **Elastic Beanstalk → Create application**. 📸
2. **Environment tier:** Web server environment. **Application name:** `fridgechef`. **Environment name:** `fridgechef-env`.
3. **Platform:** *Python*, latest Python 3 branch on Amazon Linux 2023.
4. **Application code:** *Upload your code* → version label `v1` → choose **Public S3 URL** and paste the Object URL from step 3.
   If the console rejects the URL because the object isn't public, see *Option B* below. 📸
5. **Presets:** *Single instance (free tier eligible)* → Next.
6. **Service access:** use an existing service role and EC2 instance profile, or let the console create `aws-elasticbeanstalk-service-role` / `aws-elasticbeanstalk-ec2-role`.
   *AWS Academy / Learner Lab accounts:* pick **LabRole** and **LabInstanceProfile**.
   Key pair: optional (`fridgechef-key`).
7. Networking: default VPC, **Public IP address** enabled. Leave the database section **empty**, because you're using your own RDS from step 1. Keep it separate so deleting the environment won't delete your data.
8. **Configure updates, monitoring and logging → Environment properties.** Add: 📸

| Name | Value |
|---|---|
| `DB_HOST` | your RDS endpoint |
| `DB_PORT` | `3306` |
| `DB_NAME` | `fridgechef` |
| `DB_USER` | `admin` |
| `DB_PASSWORD` | your RDS master password |
| `SECRET_KEY` | any long random text |

9. **Review → Submit.** Wait about 5 minutes until Health is **Ok (green)**. 📸

**Option B (Upload from S3 using CLI).** Use this if the console only accepts public URLs. Open **CloudShell** (the `>_` icon in the console header). Create the EB application in the console first (or with `aws elasticbeanstalk create-application --application-name fridgechef`), then:
```bash
aws elasticbeanstalk create-application-version --application-name fridgechef \
  --version-label v1 --source-bundle S3Bucket=fridgechef-code-xxx,S3Key=fridgechef-eb.zip
```
Then choose **Existing version → v1** when creating the environment.

## 5. Test
Open the environment's **Domain** URL (`http://fridgechef-env.xxxx.<region>.elasticbeanstalk.com`). 📸
- Sign up and use each module. 📸
- Open `/health`. It should show `"db_host"` = your RDS endpoint. 📸

**Part II form details:**
URL = EB domain · DB host = RDS endpoint · port `3306` · database `fridgechef` · user `evaluator` · password (yours).

## Updating the code later
- **EC2:** upload the new files, then `sudo systemctl restart fridgechef`.
- **Beanstalk:** upload a new zip to S3, then **Upload and deploy** with a new version label (`v2`).

---

# Troubleshooting

| Symptom | Fix |
|---|---|
| Browser can't reach EC2 | Security group missing HTTP 80. Make sure you're using `http://`, not `https://`. |
| `502 Bad Gateway` on EC2 | `journalctl -u fridgechef -n 50`. Usually a wrong `.env` password or missing venv packages. |
| Page says "Database unavailable" | Check DB_* values. RDS: is the security group open on 3306? |
| Grader can't connect to EC2 MySQL | `bind-address = 0.0.0.0` + restart mysql, and port 3306 open in the security group. |
| Beanstalk health Severe/Degraded | Environment → **Logs → Request last 100 lines**. Check `web.stdout.log`. Usually a DB_* environment property is wrong. |
| Beanstalk "No application found" | `application.py` isn't at the zip root. Re-zip from *inside* the project folder. |
| `ssh: Permissions are too open` | Run the `chmod 400` / `icacls` command from step 3. |

**Keep both deployments running until grading is over.** Afterwards, stop or terminate the EC2 instance, the Beanstalk environment and RDS to avoid charges.

---

# Screenshot checklist for the report
1. EC2 launch: AMI, instance type, key pair
2. Security group inbound rules
3. Instance running with its public IP
4. SSH session connected
5. `systemctl status` for mysql and nginx
6. Code uploaded (`ls`)
7. Tables + recipe count in MySQL
8. Evaluator SELECT works and DELETE is denied
9. Permissions (`ls -la`)
10. `systemctl status fridgechef` + `/health`
11. App pages on the EC2 URL
12. RDS creation and endpoint
13. RDS security group rule
14. Schema loaded into RDS
15. S3 bucket + uploaded zip
16. Beanstalk create screens (platform, code source, environment properties)
17. Beanstalk Health = Ok
18. App pages and `/health` on the Beanstalk URL
