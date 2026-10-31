-- FridgeChef sample recipes. Run after schema.sql:
--   mysql -u fridgechef -p fridgechef < seed.sql

INSERT INTO recipes (user_id, title, description, instructions, cuisine, prep_minutes, servings, difficulty) VALUES (NULL, 'Chicken Karahi', 'Classic Pakistani wok-cooked chicken in a tomato and green chilli masala.', 'Heat oil in a karahi and fry the chicken until it turns white.
Add ginger and garlic and cook for 2 minutes.
Add chopped tomatoes, salt and red chilli powder. Cover and cook until the tomatoes soften.
Cook on high heat until the oil separates.
Add green chillies and fresh coriander, then serve hot with naan.', 'Pakistani', 40, 4, 'Medium');
SET @rid = LAST_INSERT_ID();
INSERT INTO recipe_ingredients (recipe_id, name, quantity) VALUES (@rid, 'chicken', '1 kg'), (@rid, 'tomato', '4'), (@rid, 'ginger', '1 tbsp'), (@rid, 'garlic', '1 tbsp'), (@rid, 'green chilli', '4'), (@rid, 'oil', '1/2 cup'), (@rid, 'salt', 'to taste'), (@rid, 'red chilli powder', '1 tsp'), (@rid, 'coriander', 'handful');

INSERT INTO recipes (user_id, title, description, instructions, cuisine, prep_minutes, servings, difficulty) VALUES (NULL, 'Daal Chawal', 'Comforting yellow lentils served over steamed rice.', 'Wash the lentils and boil with turmeric and salt until soft.
Cook the rice separately.
Fry sliced onion, garlic and cumin in oil for the tarka.
Pour the tarka over the daal and serve with rice.', 'Pakistani', 35, 3, 'Easy');
SET @rid = LAST_INSERT_ID();
INSERT INTO recipe_ingredients (recipe_id, name, quantity) VALUES (@rid, 'lentils', '1 cup'), (@rid, 'rice', '2 cups'), (@rid, 'onion', '1'), (@rid, 'garlic', '3 cloves'), (@rid, 'turmeric', '1/2 tsp'), (@rid, 'cumin', '1 tsp'), (@rid, 'salt', 'to taste'), (@rid, 'oil', '2 tbsp');

INSERT INTO recipes (user_id, title, description, instructions, cuisine, prep_minutes, servings, difficulty) VALUES (NULL, 'Aloo Paratha', 'Flatbread stuffed with spiced mashed potatoes.', 'Knead the flour with water into a soft dough.
Boil and mash the potatoes, then mix in chilli, coriander and salt.
Stuff dough balls with the potato filling and roll them out.
Cook on a hot tawa with butter until golden on both sides.', 'Pakistani', 30, 4, 'Medium');
SET @rid = LAST_INSERT_ID();
INSERT INTO recipe_ingredients (recipe_id, name, quantity) VALUES (@rid, 'flour', '2 cups'), (@rid, 'potato', '3'), (@rid, 'green chilli', '2'), (@rid, 'coriander', '2 tbsp'), (@rid, 'butter', '2 tbsp'), (@rid, 'salt', 'to taste');

INSERT INTO recipes (user_id, title, description, instructions, cuisine, prep_minutes, servings, difficulty) VALUES (NULL, 'Egg Fried Rice', 'Quick wok fried rice, perfect for leftover rice.', 'Scramble the eggs in hot oil and set them aside.
Stir-fry the diced carrot and peas for 3 minutes.
Add the rice and soy sauce and toss on high heat.
Fold in the eggs and spring onion, then serve.', 'Chinese', 15, 2, 'Easy');
SET @rid = LAST_INSERT_ID();
INSERT INTO recipe_ingredients (recipe_id, name, quantity) VALUES (@rid, 'rice', '2 cups cooked'), (@rid, 'egg', '2'), (@rid, 'carrot', '1'), (@rid, 'peas', '1/2 cup'), (@rid, 'soy sauce', '2 tbsp'), (@rid, 'spring onion', '2'), (@rid, 'oil', '2 tbsp');

INSERT INTO recipes (user_id, title, description, instructions, cuisine, prep_minutes, servings, difficulty) VALUES (NULL, 'Creamy Chicken Alfredo', 'Pasta in a rich, garlicky cream sauce.', 'Boil the pasta in salted water and drain.
Pan-fry seasoned chicken strips in butter.
Add garlic, then the cream, and simmer for 3 minutes.
Stir in the cheese, toss with the pasta and finish with pepper.', 'Italian', 25, 3, 'Medium');
SET @rid = LAST_INSERT_ID();
INSERT INTO recipe_ingredients (recipe_id, name, quantity) VALUES (@rid, 'pasta', '250 g'), (@rid, 'chicken', '300 g'), (@rid, 'cream', '1 cup'), (@rid, 'cheese', '1/2 cup'), (@rid, 'garlic', '3 cloves'), (@rid, 'butter', '2 tbsp'), (@rid, 'black pepper', '1 tsp'), (@rid, 'salt', 'to taste');

INSERT INTO recipes (user_id, title, description, instructions, cuisine, prep_minutes, servings, difficulty) VALUES (NULL, 'Masala Omelette', 'Fluffy desi omelette with onions and chillies.', 'Beat the eggs with salt.
Mix in finely chopped onion, tomato, chilli and coriander.
Pour into a hot oiled pan and cook on both sides.', 'Pakistani', 10, 1, 'Easy');
SET @rid = LAST_INSERT_ID();
INSERT INTO recipe_ingredients (recipe_id, name, quantity) VALUES (@rid, 'egg', '3'), (@rid, 'onion', '1 small'), (@rid, 'tomato', '1'), (@rid, 'green chilli', '1'), (@rid, 'coriander', '1 tbsp'), (@rid, 'salt', 'pinch'), (@rid, 'oil', '1 tbsp');

INSERT INTO recipes (user_id, title, description, instructions, cuisine, prep_minutes, servings, difficulty) VALUES (NULL, 'Vegetable Stir Fry', 'Crunchy colourful vegetables in a garlic soy glaze.', 'Slice all the vegetables thinly.
Fry garlic in hot oil for 30 seconds.
Add the vegetables and stir-fry on high heat for 4 minutes.
Add soy sauce, toss and serve.', 'Chinese', 15, 2, 'Easy');
SET @rid = LAST_INSERT_ID();
INSERT INTO recipe_ingredients (recipe_id, name, quantity) VALUES (@rid, 'capsicum', '1'), (@rid, 'carrot', '1'), (@rid, 'cabbage', '1 cup'), (@rid, 'garlic', '2 cloves'), (@rid, 'soy sauce', '2 tbsp'), (@rid, 'oil', '1 tbsp');

INSERT INTO recipes (user_id, title, description, instructions, cuisine, prep_minutes, servings, difficulty) VALUES (NULL, 'Chana Masala', 'Chickpeas simmered in a tangy onion-tomato gravy.', 'Fry the onions until golden.
Add ginger, garlic, cumin and tomatoes and cook into a masala.
Add the chickpeas and a cup of water and simmer for 15 minutes.
Sprinkle garam masala and serve.', 'Pakistani', 30, 4, 'Easy');
SET @rid = LAST_INSERT_ID();
INSERT INTO recipe_ingredients (recipe_id, name, quantity) VALUES (@rid, 'chickpeas', '2 cups boiled'), (@rid, 'onion', '2'), (@rid, 'tomato', '2'), (@rid, 'ginger', '1 tsp'), (@rid, 'garlic', '1 tsp'), (@rid, 'cumin', '1 tsp'), (@rid, 'garam masala', '1 tsp'), (@rid, 'oil', '3 tbsp'), (@rid, 'salt', 'to taste');

INSERT INTO recipes (user_id, title, description, instructions, cuisine, prep_minutes, servings, difficulty) VALUES (NULL, 'Fluffy Pancakes', 'Weekend breakfast pancakes.', 'Whisk the flour, sugar and baking powder together.
Add milk, egg and melted butter and mix until just combined.
Cook ladlefuls on a hot pan until bubbles form, then flip.', 'Continental', 20, 3, 'Easy');
SET @rid = LAST_INSERT_ID();
INSERT INTO recipe_ingredients (recipe_id, name, quantity) VALUES (@rid, 'flour', '1 cup'), (@rid, 'milk', '1 cup'), (@rid, 'egg', '1'), (@rid, 'sugar', '2 tbsp'), (@rid, 'baking powder', '2 tsp'), (@rid, 'butter', '2 tbsp');

INSERT INTO recipes (user_id, title, description, instructions, cuisine, prep_minutes, servings, difficulty) VALUES (NULL, 'Tomato Soup', 'Smooth, warming tomato soup.', 'Saute the onion and garlic in butter.
Add chopped tomatoes and a cup of water and simmer for 15 minutes.
Blend until smooth, season, and finish with cream.', 'Continental', 25, 2, 'Easy');
SET @rid = LAST_INSERT_ID();
INSERT INTO recipe_ingredients (recipe_id, name, quantity) VALUES (@rid, 'tomato', '5'), (@rid, 'onion', '1'), (@rid, 'garlic', '2 cloves'), (@rid, 'butter', '1 tbsp'), (@rid, 'cream', '2 tbsp'), (@rid, 'salt', 'to taste'), (@rid, 'black pepper', '1/2 tsp');

INSERT INTO recipes (user_id, title, description, instructions, cuisine, prep_minutes, servings, difficulty) VALUES (NULL, 'Grilled Cheese Sandwich', 'Golden, crispy and melty.', 'Butter the outside of both bread slices.
Put the cheese between them.
Grill in a pan until both sides are golden and the cheese melts.', 'Continental', 10, 1, 'Easy');
SET @rid = LAST_INSERT_ID();
INSERT INTO recipe_ingredients (recipe_id, name, quantity) VALUES (@rid, 'bread', '2 slices'), (@rid, 'cheese', '2 slices'), (@rid, 'butter', '1 tbsp');

INSERT INTO recipes (user_id, title, description, instructions, cuisine, prep_minutes, servings, difficulty) VALUES (NULL, 'Chicken Biryani', 'Layered spiced rice and chicken, the Sunday special.', 'Fry the onions until crisp and set half aside.
Cook the chicken with ginger, garlic, tomatoes, yogurt and biryani masala.
Parboil the rice.
Layer the rice over the chicken with mint and the fried onions.
Cover tightly and cook on low heat (dum) for 20 minutes.', 'Pakistani', 75, 6, 'Hard');
SET @rid = LAST_INSERT_ID();
INSERT INTO recipe_ingredients (recipe_id, name, quantity) VALUES (@rid, 'rice', '3 cups'), (@rid, 'chicken', '1 kg'), (@rid, 'yogurt', '1 cup'), (@rid, 'onion', '3'), (@rid, 'tomato', '2'), (@rid, 'biryani masala', '1 pack'), (@rid, 'ginger', '1 tbsp'), (@rid, 'garlic', '1 tbsp'), (@rid, 'oil', '1/2 cup'), (@rid, 'mint', 'handful');
