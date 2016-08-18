#!/usr/bin/ruby

# avt - Aviaton Tools
# author: Fernando Iazeolla - iazasoft
# this software is licensed under GPLv2
# web: http://github.com/elboza/avt

require 'getoptlong'
require 'open-uri'
require 'rexml/document'
require 'pathname'

module Avt
	VERSION="0.2"
end

class GeoMetar
	attr_accessor:lat,:long,:iata,:icao,:timezone,:suffix,:dst,:day,:month,:decode,:quiet
	attr_accessor:sunrise,:sunset,:heightmeter,:heightfeet,:verbose
	def initialize
	@lat,@long,@iata,@icao,@timezone,@suffix,@dst,@day,@month=0,0,nil,nil,0,0,0,0,0
	@sunrise,@sunset,@heightmeter,@heightfeet,@decode,@quiet=0,0,0,0,false,false
	@city,@airport,@country,@countrycode,@verbose,@isotime,@localtime=nil,nil,nil,nil,false,nil,nil
	@ssv_company1,@ssv_company2,@ssv_name1,@ssv_name2,@ssv_country=nil,nil,nil,nil,nil
	@metar,@taf=nil,nil
	@path=""
	@iatafile="icao_iata.avt"
	@tailcodefile="tail_codes.avt"
	@geoiatafile="geo_iata.avt"
	@aircraftfile="aircraft_type_decode.avt"
	@ssvfile="ssv.avt"
	@gdir="/usr/share/avt/"
end

def get_iata
	ldir=""
	if @icao!=nil
	begin
		f=File.open ldir+@iatafile ,"r:UTF-8"
		a=f.readlines
		a.each do |x|
			ii=x.split ':'
			if ii[1]==@icao
				@iata=ii[0]
				@city=ii[2]
				@airport=ii[3]
				@country=ii[4]
				break
			end
		end
	rescue Errno::ENOENT
		if ldir==""
			ldir=@gdir
			retry
		else
			raise
		end
	rescue
			puts "error getting iata"
	ensure
			f.close unless f.nil?
	end #begin
	end #if
end

def get_icao
	ldir=""
	if @iata!=nil
	begin
		f=File.open ldir+@iatafile ,"r:UTF-8"
		a=f.readlines
		a.each do |x|
			ii=x.split ':'
			if ii[0]==@iata
				@icao=ii[1]
				@city=ii[2]
				@airport=ii[3]
				@country=ii[4]
				break
			end
		end
	rescue Errno::ENOENT
		if ldir==""
			ldir=@gdir
			retry
		else
			raise
		end
	rescue
			puts "error getting icao"
	ensure
			f.close unless f.nil?
	end #begin
	end #if
end

def get_geo
	ldir=""
	get_iata if @icao!=nil
	if @iata!=nil
	begin
		get_icao
		f=File.open ldir+@geoiatafile ,"r:UTF-8"
		a=f.readlines
		a.each do |x|
			ii=x.split ':'
			if ii[0]==@iata
				@lat=ii[5]
				@long=ii[6]
				@airport=ii[1]
				@city=ii[2]
				@country=ii[3]
				@countrycode=ii[4]
				break
			end
		end
	rescue Errno::ENOENT
		if ldir==""
			ldir=@gdir
			retry
		else
			raise
		end
	rescue
			puts "error getting geo"
	ensure
			f.close unless f.nil?
	end #begin
	end #if
end

def print_geo
	puts "#{@iata}-#{@icao}: #{@city}, #{@airport}, #{@country}, #{@countrycode}."
	puts "lat: #{@lat} long: #{@long}"
	puts "sunrise: #{@sunrise} sunset: #{@sunset} alt: #{@heightmeter}m(#{@heightfeet}ft)"
	puts "isotime: #{@isotime} timezone: #{@timezone}/#{@suffix} (dst: #{@dst})"
	puts "localtime: #{@localtime}"
end

def ssv_decode(code)
	ldir=""
	finded=false
	begin
		f=File.open ldir+@ssvfile ,"r:UTF-8"
		a=f.readlines
		a.each do |x|
			ii=x.split ':'
			if ii[0]==code.upcase
				@ssv_company1=ii[0]
				@ssv_company2=ii[1]
				@ssv_name1=ii[2]
				@ssv_name2=ii[3]
				@ssv_country=ii[4]
				finded=true
			end
		end
		raise "error getting ssv: code not finded" if finded==false
	rescue Errno::ENOENT
		if ldir==""
			ldir=@gdir
			retry
		else
			raise
		end
	rescue Exception=>e
		#puts "error getting ssv"
		puts e
	ensure
		f.close unless f.nil?
	end
end

def ssv_print
	puts "#{@ssv_company1} - #{@ssv_company2}, #{@ssv_name1}, #{@ssv_name2}, #{@ssv_country}"
end

def get_metar
	#metar_raw_str="http://weather.noaa.gov/pub/data/observations/metar/stations/"
	metar_raw_str="http://tgftp.nws.noaa.gov/data/observations/metar/stations/"
	#metar_decoded_str="http://weather.noaa.gov/pub/data/observations/metar/decoded/"
	metar_decoded_str="http://tgftp.nws.noaa.gov/data/observations/metar/decoded/"
	if @decode==true
		metar_str=metar_decoded_str
	else
		metar_str=metar_raw_str
	end
	metar_str+=@icao+".TXT"
	begin
		f=open metar_str
		@metar=f.readlines
	rescue
		puts "error retreiving metar data"
	ensure
		f.close unless f.nil?
	end
end

def print_metar
	@metar.each do |f|
		puts f
	end
end

def get_taf
	#taf_str="http://weather.noaa.gov/pub/data/forecasts/taf/stations/"+@icao+".TXT"
	taf_str="http://tgftp.nws.noaa.gov/data/forecasts/taf/stations/"+@icao+".TXT"
	begin
		f=open taf_str
		@taf=f.readlines
	rescue
		puts "error retreiving taf data"
	ensure
		f.close unless f.nil?
	end
end

def print_taf
	@taf.each do |f|
		puts f
	end
end

def get_geo2
	geo_str="http://new.earthtools.org/timezone/#{@lat}/#{@long}"
	geo_str2="http://new.earthtools.org/height/#{@lat}/#{@long}"
	begin
		f=open geo_str
		lines=f.read
		doc=REXML::Document.new(lines)
		doc.root.elements.each("dst") { |element| @dst=element.text}
		doc.root.elements.each("isotime") { |element| @isotime=element.text }
		doc.root.elements.each("suffix") { |element| @suffix=element.text }
		doc.root.elements.each("offset") { |element| @timezone=element.text }
		doc.root.elements.each("localtime") { |element| @localtime=element.text }
		f=open geo_str2
		lines=f.read
		doc=REXML::Document.new(lines)
		doc.root.elements.each("meters") { |element| @heightmeter=element.text }
		doc.root.elements.each("feet") { |element| @heightfeet=element.text }
	rescue Exception=>e
		puts "error getting geo data"
		puts e
	ensure
		f.close unless f.nil?
	end
	@day=@isotime.split(' ').first.split('-')[2]
	@month=@isotime.split(' ').first.split('-')[1]
	ddst=@dst=="True" ? 1 : 0
	geo_str3="http://new.earthtools.org/sun/#{@lat}/#{@long}/#{@day}/#{@month}/#{@timezone}/#{ddst}"
	p geo_str3 if @verbose
	begin
		f=open geo_str3
		lines=f.read
		doc=REXML::Document.new(lines)
		doc.root.elements.each("morning/sunrise") { |element| @sunrise=element.text }
		doc.root.elements.each("evening/sunset") { |element| @sunset=element.text }
	rescue Exception =>e
		puts "error getting geo data!"
		puts e
	ensure
		f.close unless f.nil?
	end
end

def list_file(file)
	ldir=""
	begin
		f=File.open ldir+file ,"r:UTF-8"
		a=f.readlines
		a.each do |x|
			puts x
		end
	rescue Errno::ENOENT
		if ldir==""
			ldir=@gdir
			retry
		else
			raise
		end
	rescue Exception => e
		puts "error",e
	ensure
		f.close unless f.nil?
	end
end

def tc(tcode)
	ldir=""
	begin
		f=File.open ldir+@tailcodefile ,"r:UTF-8"
		a=f.readlines
		a.each do |x|
			puts x if x.split(':').first==tcode.upcase
		end
	rescue Errno::ENOENT
		if ldir==""
			ldir=@gdir
			retry
		else
			raise
		end
	rescue Exception => e
		puts "error",e
	ensure
		f.close unless f.nil?
	end
end

def ac(tcode)
	ldir=""
	begin
		f=File.open ldir+@aircraftfile ,"r:UTF-8"
		a=f.readlines
		a.each do |x|
			puts x if x.split(':').first==tcode.upcase
		end
	rescue Errno::ENOENT
		if ldir==""
			ldir=@gdir
			retry
		else
			raise
		end
	rescue Exception => e
		puts "error",e
	ensure
		f.close unless f.nil?
	end
	end
end

def print_usage(errorcode)
	puts File.basename($0)
	puts "Aviation Tools (avt) v#{Avt::VERSION} by Fernando Iazeolla, 2013, iazasoft."
	puts <<-EOF
OPTIONS:
--metar     -m                        get metar
--taf       -f                        get taf
--geo       -g                        get geo info
--ssv       -y   <airline code>       decode airline code
--tc        -t   <tail code>          decode tail code
--quiet     -q                        silent output
--ac        -a   <aircraft type>      decode aircraft type
--verbose   -w                        verbose output
--version   -v                        displays avt version
--help      -h                        displays this help
--apt       -i   <iata or icao code>  input airport code
--decode    -d                        get decoded metar (with -m) -dm
--coord     -c                        displays latitude and longitude
--sun       -s                        displays sunrise and sunset
--list      -l   [ac|tc|ssv|geo|apt]  displays file database

examples: 
avt -i fco -gmf	 	displays geo info, metar and taf for iata's fco station
avt --ssv ek	 	decode airline code
avt -i jfk --coord	print jfk's latitude and longitude
avt --list apt |grep CDG
EOF
	exit(errorcode)
end

def main
	have_options_f=false
	avt=GeoMetar.new
	opts=GetoptLong.new(
		['--help','-h',GetoptLong::NO_ARGUMENT],
		['--metar','-m',GetoptLong::NO_ARGUMENT],
		['--taf','-f',GetoptLong::NO_ARGUMENT],
		['--geo','-g',GetoptLong::NO_ARGUMENT],
		['--ssv','-y',GetoptLong::REQUIRED_ARGUMENT],
		['--tc','-t',GetoptLong::REQUIRED_ARGUMENT],
		['--ac','-a',GetoptLong::REQUIRED_ARGUMENT],
		['--verbose','-w',GetoptLong::NO_ARGUMENT],
		['--quiet','-q',GetoptLong::NO_ARGUMENT],
		['--version','-v',GetoptLong::NO_ARGUMENT],
		['--apt','-i',GetoptLong::REQUIRED_ARGUMENT],
		['--decode','-d',GetoptLong::NO_ARGUMENT],
		['--coord','-c',GetoptLong::NO_ARGUMENT],
		['--list','-l',GetoptLong::REQUIRED_ARGUMENT],
		['--sun','-s',GetoptLong::NO_ARGUMENT]
	)
	begin
		opts.each do |opt,arg|
		case opt
		when '--version'
			puts Avt::VERSION
			exit(0)
		when '--help'
			print_usage(0)
		when '--verbose'
			avt.verbose=true
		when '--apt'
			if arg.length==3
				avt.iata=arg.upcase
				avt.get_icao
			end
			if arg.length==4
				avt.icao=arg.upcase
				avt.get_iata
			end
			if arg.length>4 or arg.length<3
				puts "invalid airport code"
				print_usage(1)
			end
			have_options_f=true
		when '--decode'
			avt.decode=true
		when '--quiet'
			avt.quiet=true
		when '--geo'
			avt.get_geo
			avt.get_geo2
			avt.print_geo
			have_options_f=true
		when '--ssv'
			avt.ssv_decode(arg)
			avt.ssv_print
			have_options_f=true
		when '--metar'
			avt.get_metar
			avt.print_metar
			have_options_f=true
		when '--taf'
			avt.get_taf
			avt.print_taf
			have_options_f=true
		when '--sun'
			avt.get_geo
			avt.get_geo2
			puts "#{avt.sunrise} / #{avt.sunset}"
			have_options_f=true
		when '--coord'
			avt.get_geo
			puts "#{avt.lat} / #{avt.long}"
			have_options_f=true
		when '--list'
			case arg
			when 'tc'
				avt.list_file "tail_codes.avt"
			when 'ac'
				avt.list_file "aircraft_type_decode.avt"
			when 'ssv'
				avt.list_file "ssv.avt"
			when 'geo'
				avt.list_file "geo_iata.avt"
			when 'apt'
				avt.list_file "icao_iata.avt"
			else
				puts "invalid option(s): try #{$0} --help"
			end
			have_options_f=true
		when '--tc'
			avt.tc(arg)
			have_options_f=true
		when '--ac'
			avt.ac(arg)
			have_options_f=true
		end #case opt
		end #each
	if have_options_f==false
		puts "no options: try '#{File.basename($0)} --help'"
		exit(1)
	end
	rescue GetoptLong::Error =>e
		puts e
		puts "invalid option(s): try '#{File.basename($0)} --help'"
		exit(1)
	end #begin
end

main
