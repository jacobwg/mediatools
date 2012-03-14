#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'highline/import'
require 'fileutils'
require 'tvdb_party'
require 'pp'

require 'renamer/constants'
require 'renamer/util'
require 'renamer/files'
require 'renamer/season'


EXTS = %w(avi mpeg xvid mp4 m4v mkv wmv mpg)

QUALITIES = [
  'cam', 'camrip',
  'ts', 'telesync',
  'scr', 'screener', 'dvdscr', 'dvdscreener',
  'r5',
  'ppvrip', 'ppv',
  'dvdrip',
  'dvdr', 'dvd',
  'hdtv', 'pdtv', 'dsr', 'dvb', 'tvrip', 'stv', 'dth',
  'bdrip', 'brrip', 'bluray', 'mkv', 'bdr', 'bd5', 'bd9'
]

FORMATS = [
  'divx', 'xvid', 'x264', '264', 'mpeg', 'wmv'
]


def lcs_size(s1, s2)

    num=Array.new(s1.size){Array.new(s2.size)}
    len,ans=0

   s1.scan(/./).each_with_index do |l1,i |
     s2.scan(/./).each_with_index do |l2,j |

        unless l1==l2
           num[i][j]=0
        else
          (i==0 || j==0)? num[i][j]=1 : num[i][j]=1 + num[i-1][j-1]
          len = ans = num[i][j] if num[i][j] > len
        end
     end
   end

   ans

end
def lcs(s1, s2)
  res=""
  num=Array.new(s1.size){Array.new(s2.size)}
  len,ans=0
  lastsub=0
  s1.scan(/./).each_with_index do |l1,i |
    s2.scan(/./).each_with_index do |l2,j |
      unless l1==l2
        num[i][j]=0
      else
        (i==0 || j==0)? num[i][j]=1 : num[i][j]=1 + num[i-1][j-1]
        if num[i][j] > len
          len = ans = num[i][j]
          thissub = i
          thissub -= num[i-1][j-1] unless num[i-1][j-1].nil?
          if lastsub==thissub
            res+=s1[i,1]
          else
            lastsub=thissub
            res=s1[lastsub, (i+1)-lastsub]
          end
        end
      end
    end
  end
  res
end

def dups_with_count array
  hash = Hash.new(0)
  array.each {|v| hash[v] += 1}
  hash.reject! { |key, value| value == 1 }
  hash
end


show_id = 75886
season_number = 1
season = Renamer::Season.new show_id, season_number

season.episodes.each do |episode|
  puts "#{episode[:name]} is episode #{episode[:number]}"
  puts "If there were parts, it would be episode #{episode[:part_number]} part #{episode[:part_letter]}"

  puts
end

files_class = Renamer::Files.new('.')
files_class.known_episodes = season.episodes



files_class.process
files = files_class.files

puts "#{files.length} Media Files Found"

files_class.files.each do |file|
  #puts file
end

=begin

begin

  #show_id = ask("What is the TMDb show ID? ")
  #season = ask("What is the season number? ")

  show_id = 75886

  show = tvdb.get_series_by_id(show_id)
  show.episodes

  files_class = Renamer::Files.new('.')
  files = files_class.files

  puts "#{files.length} Media Files Found"

  puts files_class.parts
  puts files_class.duplicate_parts
  puts files_class.common_duplicate_parts

  files.each do |file|
    puts file
    episode, score = most_similar(file, show.episodes)

    parts = file.split(/[ ,\-\.\(\)]/).compact.reject(&:empty?)
    parts.reject! { |p| QUALITIES.include? p.downcase }
    parts.reject! { |p| EXTS.include? p.downcase }
    parts.reject! { |p| FORMATS.include? p.downcase }
    puts "Filename in parts is #{parts}"



    unless parts_plus_numbers.first[:idx] == -1
      guess_title = parts[(parts_plus_numbers.first[:idx] + 1)..-1].join ' '
      episode, score = most_similar(guess_title, show.episodes)
      puts "The guessed episode title is #{guess_title}"
    end

    puts "Similar (#{score}) to #{episode.name}"

    if ep == -1
      puts "Unable to find an episode number in the filename"
      print "Using matched episode number #{episode.number}"
    else
      print "Guessed episode number is #{ep}"
    end
    print " part #{pt}" unless pt.nil?
    puts
    puts "This does NOT match the title" unless ep == episode.number


    puts "\n\n"
  end

rescue EOFError
  abort "\n^D"
rescue Interrupt
  abort "\n^C"
end

=end