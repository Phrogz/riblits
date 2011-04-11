#!/usr/bin/env ruby

module MinifyResources
	CSS_BLOB  = 'public/blob.css'
	CSS_DIR   = 'public/css'
	CSS_LIST  = 'public/css/manifest.txt'
	CSS_FILES = File.exists?(CSS_LIST) ? IO.read(CSS_LIST).scan(/\S+/) : Dir.chdir(CSS_DIR){ Dir['*.css'] }

	JS_BLOB   = 'public/blob.js'
	JS_DIR    = 'public/js'
	JS_LIST   = 'public/js/manifest.txt'
	JS_FILES  = File.exists?(JS_LIST) ? IO.read(JS_LIST).scan(/\S+/) : Dir.chdir(JS_DIR){ Dir['*.js'] }

	def self.minify_all
		require 'jsmin'
		require 'cssmin'
		minify( ::JSMin,  JS_DIR,  JS_FILES,  JS_BLOB  )
		minify( ::CSSMin, CSS_DIR, CSS_FILES, CSS_BLOB )
	end

	def self.minify( lib, source_dir, files, output )
		return if files.empty?
		require_relative 'helpers/nicebytes'
		raw_size = 0
		minified = files.map do |file|
			raw = IO.read(File.join(source_dir,file))
			raw_size += raw.length
			lib.minify(raw.dup)
		end.join
		min_size = minified.length
		existing = File.exists?(output) && IO.read(output)
		
		if minified==existing
			puts "No change to #{output}"
		else
			File.open(output,"w"){ |f| f << minified }

			puts "%i files => %s; %s => %s (%.1f%% reduction)" % [
				files.length,
				output,
				NiceBytes.nice_bytes(raw_size),
				NiceBytes.nice_bytes(min_size),
				100*(raw_size-min_size)/raw_size
			]
		end
	end
end

MinifyResources.minify_all if __FILE__==$0
