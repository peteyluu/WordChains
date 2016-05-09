require 'set'

class WordChainer

  def initialize(dictionary_file_name)
    words = File.readlines(dictionary_file_name).map(&:chomp)
    @dictionary = Set.new(words)
  end

  def build_path(target)
    path = []
    if @all_seen_words.has_key?(target)
      prev_value = target
      until prev_value.nil?
        curr_value = @all_seen_words[prev_value]
        path << prev_value
        prev_value = curr_value
      end
    end
    path
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = { source => nil }

    until @current_words.empty? || @current_words.include?(target)
      explore_current_words
    end

    path = build_path(target)
    path.reverse
  end

  def explore_current_words
    new_current_words = []
    @current_words.each do |c_word|
      adj_words = adjacent_words(c_word)
      adj_words.each do |a_word|
        if @all_seen_words.has_key?(a_word)
          next
        else
          new_current_words << a_word
          @all_seen_words[a_word] = c_word
        end
      end
    end
    @current_words = new_current_words
  end

  def adjacent_words(word)
    words = []
    word.split('').each_with_index do |old_letter, i|
      ("a".."z").to_a.each do |new_letter|
        next if old_letter == new_letter
        word_dup = word.dup
        word_dup[i] = new_letter
        words << word_dup if @dictionary.include?(word_dup)
      end
    end
    words
  end
end

if __FILE__ == $PROGRAM_NAME
  p WordChainer.new("dictionary.txt").run("duck", "rain")
end
