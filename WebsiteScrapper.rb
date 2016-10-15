require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'sqlite3'
   
page = Nokogiri::HTML(open("http://www.recipe.com/"))   

db = SQLite3::Database.open("Assignment.db")

table_name = "Myrecipes"

db.execute "create table IF not Exists '#{table_name}' (RecipeName TEXT, Publication TEXT, Description TEXT, Url TEXT, Ingredients TEXT, Directions TEXT)"
All_Recipes = page.css("div[class ~= 'recipe']")

All_Recipes.each do |recipe|
            recpname= recipe.css("h3 a").text
            url= recipe.css("h3 a")[0]['href'] 
            publication= recipe.css("span[class ~= 'publication']").text 
            description= recipe.css("p[class ~= 'description']").text 

           recipe_url =  recipe.css("h3 a")[0]['href']
           recipe_page = Nokogiri::HTML(open(recipe_url)) 
           
           ingredients= recipe_page.css("div[class ~= 'ingredients'] ul span[class ~= 'name']").text     # gives ingredients for one recipe

           directions= recipe_page.css("div[class ~= 'directions'] span[class ~= 'direction-item-content']").text          # gives directions 

         
	 puts recpname	
         puts ingredients
	puts directions
	puts "------------------"

  # for database
db.execute "INSERT INTO Myrecipes (RecipeName,Publication,Description,Url,Ingredients,Directions) VALUES('#{recpname}', '#{publication}', '#{description}', '#{url}', '#{ingredients}', '#{directions}')"
    

   
           
end

db.execute ("select RecipeName from Myrecipes")

