#!/usr/bin/env ruby

require 'rubygems'
require 'pp'

require 'iconv'

require './lib/profanity'


def timecode_to_seconds(timecode)
  seconds = 0
  timecode.gsub(/(\d{2}):(\d{2}):(\d{2}),(\d{3})/) {
    seconds  = $3.to_i
    seconds += $2.to_i * 60
    seconds += $1.to_i * 60 * 60
    seconds += ($4.to_f / 1000).to_f
  }
  
  return seconds
end


text = File.open(ARGV[0], 'r') { |f| f.read }

ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
text = ic.iconv(text + ' ')[0..-2]

text.gsub!("\r\n","\n") # fix for windows newlines

text.gsub!(/\[[^\]]*\]/,'soundfx') # fix for sound effects

edl = ''
captions = ''

text.split("\n\n").each { |subtitle|
  parts = subtitle.split("\n")

  if (not parts[2].nil? and Profanity.default.profane?(parts[2])) or (not parts[3].nil? and Profanity.default.profane?(parts[3]))
    puts "Found profanity at #{parts[1]}"
    parts[1].gsub(/(\d{2}:\d{2}:\d{2},\d{3}) --> (\d{2}:\d{2}:\d{2},\d{3})/) { |timecode|
      edl += "#{timecode_to_seconds($1) - 1} #{timecode_to_seconds($2)} 1\n"
    }
    
    puts parts[2]
    puts parts[3] if not parts[3].nil?
    
    captions += parts[0]
    captions += "\n"
    captions += parts[1]
    captions += "\n"
    captions += Profanity.default.censor(parts[2])
    captions += "\n" + Profanity.default.censor(parts[3]) if not parts[3].nil?
    captions += "\n\n"
  end
}


newFile = File.open("edl.txt", "w")
newFile.write(edl)

newFile = File.open("cleaned_captions.srt", "w")
newFile.write(captions)


