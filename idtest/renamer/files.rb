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

      @files.each_index do |idx|
        episode, score = most_similar(@files[idx][:search_title], @known_episodes)
        @files[idx][:guessed_title] = episode.name

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
      sim_score = Renamer::Util.similarity(filename, episodes.first.name)

      episodes.each do |episode|
        score = Renamer::Util.similarity(filename, episode.name)
        if score > sim_score
          sim = episode
          sim_score = score
        end
      end
      [sim, sim_score]
    end

  end
end