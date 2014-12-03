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
  v = (params[:v] ||= 0).to_i # Defines vertical baseline
  hc = '#' + (params[:hc] ||= '000000ff') # Defines horizontal baseline color
  vc = '#' + (params[:vc] ||= '000000ff') # Defines vertical baseline color

  # If no horizontal baseline specified, just sets the width to one
  width = h == 0 ? 1 : h
  # Same for height
  height = v == 0 ? 1 : v

  # Creates the PNG Image
  png = ChunkyPNG::Image.new(
    width,
    height,
    ChunkyPNG::Color::TRANSPARENT)

  # Create colors from params
  horizontal_color = ChunkyPNG::Color.from_hex(hc)
  vertical_color = ChunkyPNG::Color.from_hex(vc)

  # Draw horizontal line
  png.rect(0, v - 1, width - 1, v - 1, 
    ChunkyPNG::Color::TRANSPARENT, vertical_color) if v != 0
  # Draw vertical line if needed
  png.rect(width - 1, 0, width - 1, v - 1, 
    ChunkyPNG::Color::TRANSPARENT, horizontal_color) if h != 0

  # Returns blob data
  png.to_blob
end