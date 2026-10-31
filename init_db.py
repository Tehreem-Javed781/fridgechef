"""Create the FridgeChef database tables and load the sample recipes.

Usage (reads DB settings from .env):
    python init_db.py            create tables + sample recipes (safe to re-run)
    python init_db.py --reset    DROP all FridgeChef tables first, then recreate
"""
import sys
from application import app, query, execute, run_sql_file

TABLES = ["shopping_list", "favorites", "recipe_ingredients", "recipes", "pantry_items", "users"]

with app.app_context():
    if "--reset" in sys.argv:
        execute("SET FOREIGN_KEY_CHECKS=0")
        for t in TABLES:
            execute(f"DROP TABLE IF EXISTS {t}")
        execute("SET FOREIGN_KEY_CHECKS=1")
        print("Dropped existing tables.")
    run_sql_file("schema.sql")
    print("Tables ready:", ", ".join(r[next(iter(r))] for r in query("SHOW TABLES")))
    if query("SELECT COUNT(*) AS n FROM recipes", one=True)["n"] == 0:
        run_sql_file("seed.sql")
        print("Loaded sample recipes.")
    print("Recipes in database:", query("SELECT COUNT(*) AS n FROM recipes", one=True)["n"])
