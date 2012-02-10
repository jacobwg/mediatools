#! /usr/bin/env ruby

require 'rubygems'
require 'thepiratebay'
require 'nokogiri'
require 'open-uri'
require 'pp'

search = ARGV.join ' '

=begin
puts "You're searching for #{search}"
puts "Loading page http://btjunkie.org/search?c=4&o=52&t=1&q=#{URI.escape search}..."
page = open("http://btjunkie.org/search?c=4&o=52&t=1&q=#{URI.escape search}")
doc = Nokogiri::HTML(page)
puts "Page loaded.  Parsing..."
sub = doc.css('div#main > table.tab_results').last
puts "Identified results..."
results = sub.css('tr[onmouseout] table')
results.each do |result|
  pp result.css('th.label a').first
end
=begin
=end

#=begin
results = ThePirateBay::Search.new(search, 0, ThePirateBay::SortBy::Seeders, ThePirateBay::Category::Video).results

torrents = []

results.each do |t|

  #pp t

  parts = t[:title].split /[ .\-\(\)]/
  parts = parts.delete_if { |i| i.empty? }

  title = ''
  season = nil
  episode = nil
  quality = nil
  format = nil

  i = 0
  while i < parts.size and parts[i].match(/^s[0-9]+e[0-9]+$/i).nil?
    title += "#{parts[i]} "
    i += 1
  end
  title.strip!
  if i != parts.size
    info = parts[i].match(/^s([0-9]{1,2})e([0-9]{1,2})$/i)
    season = info[1].to_i
    episode = info[2].to_i
  end

  if title == ''
    i = 0
    while i < parts.size and parts[i].match(/^[0-9]+x[0-9]+$/i).nil?
      title += "#{parts[i]} "
      i += 1
    end
    title.strip!
    if i != parts.size
      info = parts[i].match(/^([0-9]{1,2})x([0-9]{1,2})$/i)
      season = info[1].to_i
      episode = info[2].to_i
    end
  end

  qualitites = [
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

  while i < parts.size and not qualitites.include? parts[i].downcase
    i += 1
  end
  quality = parts[i].downcase if i != parts.size

  formats = [
    'divx', 'xvid', 'x264', '264', 'mpeg', 'wmv'
  ]

  while i < parts.size and not formats.include? parts[i].downcase
    i += 1
  end
  format = parts[i].downcase if i != parts.size

  if not season.nil? and not episode.nil? and not quality.nil? and not format.nil?

    torrent = {
      :title => title,
      :seeders => t[:seeders],
      :leechers => t[:leechers],
      :link => t[:torrent_link],
      :season => season,
      :episode => episode,
      :quality => quality,
      :format => format
    }
    torrents.push torrent

  end

  #pp parts

end

seasons = {}

torrents.sort! { |a,b| a[:seeders] <=> b[:seeders] }
torrents.reverse!

torrents.each do |torrent|

  if seasons["#{torrent[:season]}"].nil?
    seasons["#{torrent[:season]}"] = {}
  end

  if seasons["#{torrent[:season]}"]["#{torrent[:episode]}"].nil?
    seasons["#{torrent[:season]}"]["#{torrent[:episode]}"] = {}
  end

  if seasons["#{torrent[:season]}"]["#{torrent[:episode]}"][torrent[:quality]].nil?
    seasons["#{torrent[:season]}"]["#{torrent[:episode]}"][torrent[:quality]] = {}
  end

  if seasons["#{torrent[:season]}"]["#{torrent[:episode]}"][torrent[:quality]][torrent[:format]].nil?
    seasons["#{torrent[:season]}"]["#{torrent[:episode]}"][torrent[:quality]][torrent[:format]] = []
  end

  #if seasons["#{torrent[:season]}"]["#{torrent[:episode]}"][torrent[:quality]][torrent[:format]].nil? or seasons["#{torrent[:season]}"]["#{torrent[:episode]}"][torrent[:quality]][torrent[:format]][:seeders] < torrent[:seeders]

  seasons["#{torrent[:season]}"]["#{torrent[:episode]}"][torrent[:quality]][torrent[:format]].push torrent

end

seasons.each do |season, episodes|
  puts "Season #{season}"
  episodes.each do |episode, qualities|
    puts "\tEpisode #{episode}"
    qualities.each do |quality, formats|
      puts "\t\tQuality #{quality}"
      formats.each do |format, torrents|
        puts "\t\t\tFormat #{format}"
        torrents.each do |torrent|
          puts "\t\t\t\t#{torrent[:title]} (#{torrent[:seeders]})"
        end
      end
    end
  end
end



require 'rss/maker'

version = "2.0" # ["0.9", "1.0", "2.0"]
destination = "shows.xml" # local file to write

content = RSS::Maker.make(version) do |m|
m.channel.title = "Torrent Results for #{search}"
m.channel.link = "http://thepiratebay.org/"
m.channel.description = "Correctly processed TV torrent downloads"
#m.items.do_sort = true # sort items by date


torrents.each do |torrent|

  i = m.items.new_item
  i.title = "#{torrent[:title]} - S#{'%02d' % torrent[:season]}E#{'%02d' % torrent[:episode]} - #{torrent[:quality]} - #{torrent[:format]}"
  i.link = torrent[:link]

end

end


File.open(destination,"w") do |f|
f.write(content)
end

=begin
=end
