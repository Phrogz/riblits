# encoding: utf-8
require 'sinatra/base'

module Sinatra
	module PartialPartials
		def local_get(url)
			call(env.merge("PATH_INFO" => url)).last.join
		end

		def partial( page, variables={} )
			haml page, {layout:false}, variables
		end
	end
	helpers PartialPartials
end