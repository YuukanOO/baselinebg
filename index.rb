require 'sinatra'
require 'chunky_png'

########################################
### USER SPECIFIC CONFIGURATION
########################################

bind_address = 'localhost' # Where to listen?
bind_port = 5555 # What port?
# Edit the base url if you're behind a reverse proxy
base_url = "http://#{bind_address}:#{bind_port}"

########################################
### END USER SPECIFIC CONFIGURATION
########################################

# Defines sinatra options
set :bind, bind_address
set :port, bind_port

# Show the landing page
get '/' do
  # Render the index page and computes the domain for the bookmarlet
  erb :index, :locals => { 
    :domain => base_url }
end

# Generates a baseline
get '/g/' do
  content_type 'image/png' # Defines the content type

  h = (params[:h] ||= 0).to_i # Defines horizontal baseline
  v = (params[:v] ||= 24).to_i # Defines vertical baseline
  r = (params[:r] ||= 0).to_i # Define R color
  g = (params[:g] ||= 0).to_i # Define G color
  b = (params[:b] ||= 0).to_i # Define B color
  a = (params[:a] ||= 255).to_i # Define alpha color

  # If no horizontal baseline specified, just sets the width to one
  w = h == 0 ? 1 : h

  # Creates the PNG Image
  png = ChunkyPNG::Image.new(
    w,
    v,
    ChunkyPNG::Color::TRANSPARENT)

  # And the color
  color = ChunkyPNG::Color.rgba(r, g, b, a)

  # Draw horizontal line
  png.rect(0, v - 1, w - 1, v - 1, ChunkyPNG::Color::TRANSPARENT, color)
  # Draw vertical line if needed
  png.rect(w - 1, 0, w - 1, v - 1, ChunkyPNG::Color::TRANSPARENT, color) if h != 0

  # Returns blob data
  png.to_blob
end