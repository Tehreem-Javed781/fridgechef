# Run FridgeChef on your own computer (Windows)

FridgeChef is a Flask (Python) web app that stores its data in MySQL. To run it locally you need **Python**, **MySQL**, and the project folder. Plan on about 20 minutes, most of it installing.

---

## 1. Install Python
1. Download **Python 3.12** from https://www.python.org/downloads/windows/ (the "Windows installer (64-bit)").
2. On the first installer screen, tick **"Add python.exe to PATH"**, then click **Install Now**.
3. Open **PowerShell** and check that it worked:
   ```powershell
   python --version        # Python 3.12.x
   ```

## 2. Install MySQL
1. Download **MySQL Installer for Windows** from https://dev.mysql.com/downloads/installer/ (the larger "mysql-installer-community" file). On the download page, click **"No thanks, just start my download"**.
2. Run it. Choose **Custom** and add **MySQL Server 8.x** and **MySQL Shell** (or pick **Server only** if you prefer).
3. Keep the defaults (port **3306**, "Strong password encryption").
4. When asked, set a **root password** and remember it.
5. Leave "Configure MySQL Server as a Windows Service" ticked, so MySQL starts automatically.

> Already have **XAMPP**? Its MySQL (MariaDB) works too. Start MySQL from the XAMPP Control Panel. The root user has no password by default.

## 3. Unzip the project
Extract `fridgechef.zip` to a simple path, for example `C:\Projects\fridgechef`. Inside you should see `application.py`, `init_db.py`, `requirements.txt` and the `templates` and `static` folders.

## 4. Create the database and its user
Open **MySQL 8.x Command Line Client** from the Start menu (or MySQL Workbench) and enter your root password. Then run:
```sql
CREATE DATABASE fridgechef CHARACTER SET utf8mb4;
CREATE USER 'fridgechef'@'localhost' IDENTIFIED BY 'MiseLocal@2026';
GRANT ALL PRIVILEGES ON fridgechef.* TO 'fridgechef'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```
(XAMPP: open the **Shell** from the control panel, run `mysql -u root`, then the same lines.)

## 5. Set up Python for the project
In **PowerShell**:
```powershell
cd C:\Projects\fridgechef
python -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
```
If PowerShell says *"running scripts is disabled on this system"*, run this once, then try `Activate.ps1` again:
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```
Once activated, your prompt starts with `(venv)`.

## 6. Configure the connection
```powershell
copy .env.example .env
notepad .env
```
Set the values to match step 4:
```
DB_HOST=localhost
DB_PORT=3306
DB_NAME=fridgechef
DB_USER=fridgechef
DB_PASSWORD=MiseLocal@2026
SECRET_KEY=any-long-random-text-you-like
```
Save and close Notepad.

## 7. Create the tables and sample recipes
```powershell
python init_db.py
```
You should see:
```
Tables ready: favorites, pantry_items, recipe_ingredients, recipes, shopping_list, users
Loaded sample recipes.
Recipes in database: 12
```
To wipe everything and start fresh later, run `python init_db.py --reset`.

## 8. Start the website
```powershell
python application.py
```
Open **http://localhost:5000** in your browser. Leave the PowerShell window open while you use the site, and press `Ctrl + C` to stop it.

Next time you only need:
```powershell
cd C:\Projects\fridgechef
.\venv\Scripts\Activate.ps1
python application.py
```

## 9. Try every module
1. **Create account** with your name, email and a password of 6+ characters.
2. **My fridge:** add egg, onion, tomato, green chilli, coriander and rice. Give two of them a use-by date of tomorrow.
3. **Today:** the dashboard shows your counts, your best recipe tickets, and the items to use soon.
4. **What can I cook:** Masala Omelette should sit under *Ready to cook* at 100%.
5. **Recipes:** search "chicken", filter by cuisine, then **Publish a recipe** of your own, edit it, and delete it.
6. Open any recipe and choose **Save recipe**. It then appears under **Saved**.
7. On a recipe with missing ingredients, choose **Add missing to shopping list**. In **Shopping list**, tick an item, then use **Move to fridge**.
8. Visit **http://localhost:5000/health**. It shows `"database":"connected"` and the recipe count.

---

## Troubleshooting

| What you see | Fix |
|---|---|
| `python` is not recognized | Reinstall Python with **Add to PATH** ticked, then open a new PowerShell window. |
| Page says *"FridgeChef can't reach its database"* | Check MySQL is running: Windows search → **Services** → MySQL80 → Start. Then check the `.env` values match step 4. |
| `Access denied for user 'fridgechef'@'localhost'` | The password in `.env` doesn't match step 4. Fix it, or rerun the `CREATE USER` line with the right password. |
| `Unknown database 'fridgechef'` | Step 4's `CREATE DATABASE` didn't run. Run it again. |
| `ModuleNotFoundError: No module named 'flask'` | The venv isn't active. Run `.\venv\Scripts\Activate.ps1` first. |
| Port 5000 already in use | Run `$env:PORT=5050; python application.py` and open http://localhost:5050. |
