module Renamer
  class Util
    class << self
      def similarity(str1, str2)
        str1 = str1.dup
        str2 = str2.dup
        str1.downcase!
        pairs1 = (0..str1.length-2).collect {|i| str1[i,2]}.reject {
          |pair| pair.include? " "}
        str2.downcase!
        pairs2 = (0..str2.length-2).collect {|i| str2[i,2]}.reject {
          |pair| pair.include? " "}
        union = pairs1.size + pairs2.size
        intersection = 0
        pairs1.each do |p1|
          0.upto(pairs2.size-1) do |i|
            if p1 == pairs2[i]
              intersection += 1
              pairs2.slice!(i)
              break
            end
          end
        end
        (2.0 * intersection) / union
      end


    end
  end
end