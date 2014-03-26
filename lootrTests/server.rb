# Sinatra Mocking Server
# Run with `ruby server.rb` before executing the test suite within Xcode
# Install sinatra with `sudo gem install sinatra`

require 'rubygems'
require 'sinatra'
require 'json'

configure do
  set :port, 8081
  set :logging, true
  set :dump_errors, true
  set :public_folder, Proc.new { File.expand_path(File.join(root, 'Fixtures')) }
end

def render_fixture(filename)
  send_file File.join(settings.public_folder, filename)
end

# Creates a route that will match /api/loots/lat/47.226/long/8.818/distance/100
# PUNKT nicht KOMMA
get '/lootrserver/api/loots/lat/:lat/long/:long/distance/:dist' do
  render_fixture('lootList.json')
end


# Creates a route that will match /api/loots/lat/47.226/long/8.818/count/4
# PUNKT nicht KOMMA
get '/lootrserver/api/loots/lat/:lat/long/:long/count/:count' do
  render_fixture('lootList.json')
end


# Creates a route that will match /api/loots/id/3
# PUNKT nicht KOMMA
get '/lootrserver/api/loots/id/:id' do
  render_fixture('lootSingle.json')
end









# Creates a route that will match /api/activity/<article ID>
get '/api/activity/:id' do
  render_fixture('activity.json')
end

get '/api/activities' do
  render_fixture('activities.json')
end

get '/api/checkin' do
  render_fixture('checkin.json')
  status 200
end

get '/api/Login' do
  render_fixture('token.json')
  status 200
end

get '/api/hash' do
  render_fixture('hash.json')
  status 200
end

get '/api/peoplecount' do
  render_fixture('peoplecount.json')
  status 200
end

get '/api/setting' do
  render_fixture('settings.json')
  status 200
end

get '/api/locationvisibilities' do
  render_fixture('locationvisibilities.json')
  status 200
end

# Return a 503 response to test error conditions
get '/offline' do
  status 503
end

# Simulate a JSON error
get '/error' do
  status 400
  content_type 'application/json'
  "{\"error\": \"An error occurred!!\"}"
end