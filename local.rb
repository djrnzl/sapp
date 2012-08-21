require 'rack'


puts '============================================'
puts "=== And tonight ===\n"

dir = File.dirname File.expand_path($0)
require dir + '/sapp'

app = Rack::Builder.new do
	use Rack::CommonLogger
	use Rack::ShowExceptions

	map '/static' do
		run Rack::Directory.new '/home/djr/dropbox/djr.vps/www/djrsnot/public/static'
	end
	
	map '/images' do
		run Rack::Directory.new '/home/djr/dropbox/djr.vps/www/djrsnot/public/images'
	end
	
	map '/' do
		use Rack::Lint
		use Rack::Reloader
		run Sina::Application
	end

end

puts "============================================
Rack powered up... check!
At http://localhost
============================================"

Rack::Handler::Thin.run app, :Port => 8082
 
