#require "httparty"
#require 'pry'

class EdemamApiWrapper
  BASE_URL = "https://api.edamam.com/search?"
  APP_ID = ENV["APP_ID"]
  APP_KEY= ENV["APP_KEY"]
  END_URL = "&app_id=$#{APP_ID}&app_key=$#{APP_KEY}"

  def self.list_recipes(search_term)
    puts "Searching for #{search_term}"
    url = BASE_URL + "q=" + search_term
    response = HTTParty.post(url)
    hits = response.parsed_response["hits"]
    recipe_list = []
    if hits
      hits.each do |hit|
        recipe_list << create_recipe(hit)
      end
    end
    return recipe_list
  end

  def self.find_a_recipe(uri)
    #uri = the end of the long uri?
    url = BASE_URL + "r=" + uri
    response = HTTParty.post(url)
    hit = response.parsed_response["hits"]
    return create_recipe(hit)
  end


  private

  def self.create_recipe(api_params)
    label = api_params["recipe"]["label"]
    recipe_url = api_params["recipe"]["shareAs"]
    ingredients = api_params["recipe"]["ingredientLines"]
    dietary = api_params["recipe"]["healthLabels"]
    image = api_params["recipe"]["image"]
    source = api_params["recipe"]["source"]
    uri = api_params["recipe"]["uri"]
    return Recipe.new(label, recipe_url, ingredients, dietary, image, source, uri)
  end

end