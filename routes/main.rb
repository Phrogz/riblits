# encoding: utf-8
class MyApp < Sinatra::Application
	get "/" do
		@title = "Welcome to MyApp"				
		haml :main
	end
end