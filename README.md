# FridgeChef

Cook with what you already have. A Flask + MySQL web app for the DevOps for Cloud Computing assignment.

**Modules:** Authentication · My Fridge (inventory + expiry) · Recipes (CRUD + search) · Cook Match (recipe ranking) · Favorites & Shopping List

Run locally:
    python3 -m venv venv && venv/bin/pip install -r requirements.txt
    cp .env.example .env   # fill in DB settings, then export them
    python init_db.py
    venv/bin/python application.py      # http://localhost:5000

See SETUP_LOCAL.md to run it on your own computer, and DEPLOY.md for the step-by-step EC2 and Elastic Beanstalk deployment.
