"""Generates seed.sql (12 sample recipes). Run: python3 tools/make_seed.py"""
R = [
 ("Chicken Karahi","Classic Pakistani wok-cooked chicken in a tomato and green chilli masala.","Pakistani",40,4,"Medium",
  [("chicken","1 kg"),("tomato","4"),("ginger","1 tbsp"),("garlic","1 tbsp"),("green chilli","4"),("oil","1/2 cup"),("salt","to taste"),("red chilli powder","1 tsp"),("coriander","handful")],
  ["Heat oil in a karahi and fry the chicken until it turns white.","Add ginger and garlic and cook for 2 minutes.","Add chopped tomatoes, salt and red chilli powder. Cover and cook until the tomatoes soften.","Cook on high heat until the oil separates.","Add green chillies and fresh coriander, then serve hot with naan."]),
 ("Daal Chawal","Comforting yellow lentils served over steamed rice.","Pakistani",35,3,"Easy",
  [("lentils","1 cup"),("rice","2 cups"),("onion","1"),("garlic","3 cloves"),("turmeric","1/2 tsp"),("cumin","1 tsp"),("salt","to taste"),("oil","2 tbsp")],
  ["Wash the lentils and boil with turmeric and salt until soft.","Cook the rice separately.","Fry sliced onion, garlic and cumin in oil for the tarka.","Pour the tarka over the daal and serve with rice."]),
 ("Aloo Paratha","Flatbread stuffed with spiced mashed potatoes.","Pakistani",30,4,"Medium",
  [("flour","2 cups"),("potato","3"),("green chilli","2"),("coriander","2 tbsp"),("butter","2 tbsp"),("salt","to taste")],
  ["Knead the flour with water into a soft dough.","Boil and mash the potatoes, then mix in chilli, coriander and salt.","Stuff dough balls with the potato filling and roll them out.","Cook on a hot tawa with butter until golden on both sides."]),
 ("Egg Fried Rice","Quick wok fried rice, perfect for leftover rice.","Chinese",15,2,"Easy",
  [("rice","2 cups cooked"),("egg","2"),("carrot","1"),("peas","1/2 cup"),("soy sauce","2 tbsp"),("spring onion","2"),("oil","2 tbsp")],
  ["Scramble the eggs in hot oil and set them aside.","Stir-fry the diced carrot and peas for 3 minutes.","Add the rice and soy sauce and toss on high heat.","Fold in the eggs and spring onion, then serve."]),
 ("Creamy Chicken Alfredo","Pasta in a rich, garlicky cream sauce.","Italian",25,3,"Medium",
  [("pasta","250 g"),("chicken","300 g"),("cream","1 cup"),("cheese","1/2 cup"),("garlic","3 cloves"),("butter","2 tbsp"),("black pepper","1 tsp"),("salt","to taste")],
  ["Boil the pasta in salted water and drain.","Pan-fry seasoned chicken strips in butter.","Add garlic, then the cream, and simmer for 3 minutes.","Stir in the cheese, toss with the pasta and finish with pepper."]),
 ("Masala Omelette","Fluffy desi omelette with onions and chillies.","Pakistani",10,1,"Easy",
  [("egg","3"),("onion","1 small"),("tomato","1"),("green chilli","1"),("coriander","1 tbsp"),("salt","pinch"),("oil","1 tbsp")],
  ["Beat the eggs with salt.","Mix in finely chopped onion, tomato, chilli and coriander.","Pour into a hot oiled pan and cook on both sides."]),
 ("Vegetable Stir Fry","Crunchy colourful vegetables in a garlic soy glaze.","Chinese",15,2,"Easy",
  [("capsicum","1"),("carrot","1"),("cabbage","1 cup"),("garlic","2 cloves"),("soy sauce","2 tbsp"),("oil","1 tbsp")],
  ["Slice all the vegetables thinly.","Fry garlic in hot oil for 30 seconds.","Add the vegetables and stir-fry on high heat for 4 minutes.","Add soy sauce, toss and serve."]),
 ("Chana Masala","Chickpeas simmered in a tangy onion-tomato gravy.","Pakistani",30,4,"Easy",
  [("chickpeas","2 cups boiled"),("onion","2"),("tomato","2"),("ginger","1 tsp"),("garlic","1 tsp"),("cumin","1 tsp"),("garam masala","1 tsp"),("oil","3 tbsp"),("salt","to taste")],
  ["Fry the onions until golden.","Add ginger, garlic, cumin and tomatoes and cook into a masala.","Add the chickpeas and a cup of water and simmer for 15 minutes.","Sprinkle garam masala and serve."]),
 ("Fluffy Pancakes","Weekend breakfast pancakes.","Continental",20,3,"Easy",
  [("flour","1 cup"),("milk","1 cup"),("egg","1"),("sugar","2 tbsp"),("baking powder","2 tsp"),("butter","2 tbsp")],
  ["Whisk the flour, sugar and baking powder together.","Add milk, egg and melted butter and mix until just combined.","Cook ladlefuls on a hot pan until bubbles form, then flip."]),
 ("Tomato Soup","Smooth, warming tomato soup.","Continental",25,2,"Easy",
  [("tomato","5"),("onion","1"),("garlic","2 cloves"),("butter","1 tbsp"),("cream","2 tbsp"),("salt","to taste"),("black pepper","1/2 tsp")],
  ["Saute the onion and garlic in butter.","Add chopped tomatoes and a cup of water and simmer for 15 minutes.","Blend until smooth, season, and finish with cream."]),
 ("Grilled Cheese Sandwich","Golden, crispy and melty.","Continental",10,1,"Easy",
  [("bread","2 slices"),("cheese","2 slices"),("butter","1 tbsp")],
  ["Butter the outside of both bread slices.","Put the cheese between them.","Grill in a pan until both sides are golden and the cheese melts."]),
 ("Chicken Biryani","Layered spiced rice and chicken, the Sunday special.","Pakistani",75,6,"Hard",
  [("rice","3 cups"),("chicken","1 kg"),("yogurt","1 cup"),("onion","3"),("tomato","2"),("biryani masala","1 pack"),("ginger","1 tbsp"),("garlic","1 tbsp"),("oil","1/2 cup"),("mint","handful")],
  ["Fry the onions until crisp and set half aside.","Cook the chicken with ginger, garlic, tomatoes, yogurt and biryani masala.","Parboil the rice.","Layer the rice over the chicken with mint and the fried onions.","Cover tightly and cook on low heat (dum) for 20 minutes."]),
]
def q(s): return "'" + s.replace("\\","\\\\").replace("'","''") + "'"
out = ["-- FridgeChef sample recipes. Run after schema.sql:","--   mysql -u fridgechef -p fridgechef < seed.sql",""]
for t,d,c,m,s,diff,ings,steps in R:
    out.append(f"INSERT INTO recipes (user_id, title, description, instructions, cuisine, prep_minutes, servings, difficulty) VALUES (NULL, {q(t)}, {q(d)}, {q(chr(10).join(steps))}, {q(c)}, {m}, {s}, {q(diff)});")
    out.append("SET @rid = LAST_INSERT_ID();")
    out.append("INSERT INTO recipe_ingredients (recipe_id, name, quantity) VALUES " + ", ".join(f"(@rid, {q(n)}, {q(x)})" for n,x in ings) + ";")
    out.append("")
txt = "\n".join(out)
assert txt.count(";") == 3*len(R)
open(__file__.rsplit("/tools/",1)[0] + "/seed.sql","w").write(txt)
print("wrote seed.sql")
