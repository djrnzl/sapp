# Rack App
# sapp.rb

module Sina
	
	require 'sinatra/base'
	require 'erector'
	require 'redcloth'

	class Store
		@@basedir = "#{Dir.getwd}/pages/"
		@@bad_path = Regexp.new '\.+|\/\/+'
		
		def self.get page
			content = self.read page.to_s
			while content =~ /\[insert:.+\]/
				match = $~.to_s
				key , value = match.gsub(/\[|\]/,'').split(':')
				content.gsub!(match, self.read(value)) if key == 'insert'
			end
			return content
		end
		
		def self.read page
			return false if page =~ @@bad_path
			if File.exist?("#{@@basedir}#{page}.textile")
				File.open("#{@@basedir}#{page}.textile"){|file| file.read}
			else
				return false
			end
		end
		
	end

	class Render
		def self.method_missing(m,*a,&b)
			Views.new(:_v=>m,:_d=>a,:_b=>b).to_pretty
		end
	end

	class Views < Erector::Widget
		def content
			self.respond_to?(@_v,true) ? (send @_v , *@_d , &@_b) : (send :no_view)
		end
		def no_view
			template{
				h1 "The view '#{@_v.to_s}' is not defined!"
			}
		end
	end

	class Application < Sinatra::Base

		reset!

		get '/*' do
			page = params[:splat][0].to_s
			page = 'index' if page.empty?
			content = Store.get page
			halt 404 if not content
			Render.view content
		end
	end # Application

	class Views # HTML Views

		def header page_title = "DJRSNOT"
			html{
				head{
					title page_title
					css '/static/main.css'
				}
				body{yield}
			}
		end

		def view textile
			header{
				div raw RedCloth.new(textile.to_s).to_html
			}
		end		
	end # Views
	
end # Module
