module Renamer
  class Season

    attr_accessor :tvdb_id, :season_number, :tvdb, :show, :episodes, :airdate

    def initialize tvdb_id, season_number
      @tvdb_id = tvdb_id
      @season_number = season_number
      @tvdb = TvdbParty::Search.new(ENV['TVDB_KEY'])
      @show = tvdb.get_series_by_id(@tvdb_id)
      @episodes = show.episodes.reject { |e| e.season_number.to_i != @season_number }

      @episodes = @episodes.to_a.map do |episode|
        {
          :name => episode.name,
          :number => episode.number.to_i,
          :overview => episode.overview,
          :air_date => episode.air_date,
          :id => episode.id.to_i
        }
      end

      @airdate = Hash.new { |hash, key| hash[key] = [] }
      @episodes.each do |episode|
        @airdate[episode[:air_date].to_s] << episode
      end

      @airdate.each do |airdate, episodes|
        counter = 0
        episodes.each do |episode|
          episode[:part_letter] = PARTS[counter]
          counter += 1
        end
      end

      last_part = '-1'
      part_number = 1
      @episodes.first[:part_number] = part_number
      @episodes[1..-1].each do |episode|
        part_number += 1 if episode[:part_letter] == 'a'
        episode[:part_number] = part_number
      end

    end

  end
end