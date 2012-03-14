module Renamer
  class Files

    COMMON_RATIO = 0.70 # if a string is in 70% of filenames, it is common

    def initialize directory
      @directory = directory
      @files = @parts = @duplicate_parts = @common_duplicate_parts = @known_episodes = []
    end

    def load
      files = []
      EXTS.each do |ext|
        new_files = Dir.glob("#{@directory}/*.#{ext}")
        next if new_files.empty?
        files += new_files
      end

      files.sort!
    end

    def process
      @files = load

      @files.map! do |f|
        name = f.gsub("#{@directory}/", '')
        {
          :name => name,
          :parts => name.split(/[ ,\-\.\(\)]/).compact.reject(&:empty?).reject do |p|
            QUALITIES.include?(p.downcase) or FORMATS.include?(p.downcase) or EXTS.include?(p.downcase)
          end
        }
      end

      @parts = Hash.new(0)
      @files.each do |file|
        file[:parts].each do |part|
          @parts[part.downcase] += 1
        end
      end

      @duplicate_parts = @parts.reject do |part, count|
        count < 2
      end

      threshhold = @files.count.to_f * COMMON_RATIO
      @common_duplicate_parts = @parts.reject { |part, count| count < threshhold }

      @files.each_index do |idx|
        @files[idx][:search_title] = @files[idx][:parts].reject do |p|
          @common_duplicate_parts.include? p.downcase
        end.join ' '
      end
=begin
      @files.each_index do |idx|
        parts_plus_numbers = []
        episode[:parts].each_index do |idx|
          guess_one, guess_two, guess_three, guess_four = find_numbers episode[:parts][idx]
          guess_episode = nil
          guess_part = nil
          guess_finder = -1

          unless guess_four.empty?
            guess_episode = guess_four.first[0].to_i
            guess_part = guess_four.first[1]
            guess_finder = 4
          end

          unless guess_three.empty?
            guess_episode = -1
            guess_finder = 3
          end

          unless guess_two.empty?
            guess_episode = guess_two.first[1]
            guess_part = guess_two.first[2]
            guess_finder = 2
          end

          unless guess_one.empty?
            guess_episode = guess_one.first[1]
            guess_part = guess_one.first[2]
            guess_finder = 1
          end

          parts_plus_numbers << {
            :idx => idx,
            :guess_finder => guess_finder,
            :guess_episode => guess_episode.to_i,
            :guess_part => guess_part
          }
        end

        parts_plus_numbers.sort! { |a,b| b[:guess_finder] <=> a[:guess_finder] }

        ep = parts_plus_numbers.first[:guess_episode]
        pt = parts_plus_numbers.first[:guess_part]
      end
=end
      @files.each_index do |idx|
        episode, score = most_similar(@files[idx][:search_title], @known_episodes)
        @files[idx][:guessed_title] = episode[:name]

        @files[idx][:guessed_episode] = episode
        @files[idx][:guessed_title_score] = score
      end

    end

    def files
      @files
    end

    def parts
      @parts
    end

    def duplicate_parts
      @duplicate_parts
    end

    def common_duplicate_parts
      @common_duplicate_parts
    end

    def known_episodes
      @known_episodes
    end

    def known_episodes= ke
      @known_episodes = ke
    end

    protected

    def most_similar filename, episodes
      sim = episodes.first
      sim_score = Renamer::Util.similarity(filename, episodes.first[:name])

      episodes.each do |episode|
        score = Renamer::Util.similarity(filename, episode[:name])
        if score > sim_score
          sim = episode
          sim_score = score
        end
      end
      [sim, sim_score]
    end

    def find_numbers string
      guess_one = string.scan /S(\d{1,2})E(\d{1,2})([a-z])?/i

      # Format: 001x001
      guess_two = string.scan /(\d{1,3})x(\d{1,3})([a-z])?/i

      # Format: S001
      guess_three = string.scan /S(\d{1,2})/i

      # Format: 001
      guess_four = string.scan /(\d{1,2})([a-z])?/i

      [guess_one, guess_two, guess_three, guess_four]

    end

  end
end