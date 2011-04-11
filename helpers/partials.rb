# encoding: utf-8
require 'sinatra/base'

module Sinatra
	module PartialPartials
		ENV_PATHS = %w[ REQUEST_PATH PATH_INFO REQUEST_URI ] 
		def spoof_request( uri, headers=nil ) 
			new_env = env.dup 
			ENV_PATHS.each{ |k| new_env[k] = uri.to_s } 
			new_env.merge!(headers) if headers
			call( new_env ).last.join 
		end

		def partial( page, variables={} )
			haml page, {layout:false}, variables
		end
	end
	helpers PartialPartials
end