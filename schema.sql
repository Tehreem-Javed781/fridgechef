-- FridgeChef database schema (MySQL 8 / MariaDB)
-- Run:  mysql -u fridgechef -p fridgechef < schema.sql

CREATE TABLE IF NOT EXISTS users (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  email         VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS pantry_items (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  user_id     INT NOT NULL,
  name        VARCHAR(100) NOT NULL,
  quantity    DECIMAL(10,2) NOT NULL DEFAULT 1,
  unit        VARCHAR(20) NOT NULL DEFAULT 'pcs',
  category    VARCHAR(50) NOT NULL DEFAULT 'Other',
  expiry_date DATE NULL,
  added_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_pantry_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_pantry_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS recipes (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  user_id      INT NULL,
  title        VARCHAR(150) NOT NULL,
  description  TEXT,
  instructions TEXT NOT NULL,
  cuisine      VARCHAR(50) NOT NULL DEFAULT 'Other',
  prep_minutes INT NOT NULL DEFAULT 15,
  servings     INT NOT NULL DEFAULT 2,
  difficulty   VARCHAR(10) NOT NULL DEFAULT 'Easy',
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_recipe_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS recipe_ingredients (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  recipe_id INT NOT NULL,
  name      VARCHAR(100) NOT NULL,
  quantity  VARCHAR(50) DEFAULT '',
  CONSTRAINT fk_ing_recipe FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE,
  INDEX idx_ing_recipe (recipe_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS favorites (
  user_id    INT NOT NULL,
  recipe_id  INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, recipe_id),
  CONSTRAINT fk_fav_user   FOREIGN KEY (user_id)   REFERENCES users(id)   ON DELETE CASCADE,
  CONSTRAINT fk_fav_recipe FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS shopping_list (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  user_id    INT NOT NULL,
  name       VARCHAR(100) NOT NULL,
  quantity   VARCHAR(50) DEFAULT '',
  is_bought  TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_shop_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
