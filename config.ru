# config.ru

require './sapp.rb'

# set :environment, :production
use Rack::ShowExceptions
run Sina::Application.new
