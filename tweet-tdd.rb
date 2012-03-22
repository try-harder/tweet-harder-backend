# encoding: UTF-8

Encoding.default_external = Encoding::UTF_8 if defined? Encoding

require 'minitest/autorun'

class TweetTest < MiniTest::Unit::TestCase

  # ("" << 333).ord

  def setup
    @terms = {
      "cat" => { id: 333 },
      "dog" => { id: 444 }
    }
  end

  def test_encode_word
    assert_equal "ō", encode("cat")
  end

  def test_encode_word_fail
    refute_equal "ō", encode("dog")
  end

  def test_decode_word
    assert_equal "cat", decode("ō")
  end
  
  def test_decode_word_fail
    refute_equal "cat", decode("Ƽ")
  end

  def test_encode_words
    assert_equal "ōƼ", encode_all("cat dog")
  end

  def test_encode_words_fail
    refute_equal "ōƼ", encode_all("dog cat")
  end

  def test_decode_words
    assert_equal "cat dog", decode_all("ōƼ")
  end

  def test_decode_words_fail
    refute_equal "cat dog", decode_all("Ƽō")
  end


  def encode(word)
    "" << @terms[word][:id]
  end

  def encode_all(words)
    (words.split.map{|word| encode(word)}).join
  end

  def decode(char)
    flipped_terms[char.ord][:term]
  end

  def decode_all(chars)
    (chars.split("").map {|char| decode(char)}).join(" ")
  end

  def flipped_terms
    result = {}
    @terms.each { |key, val| result[val[:id]] = {term: key} }
    result
  end

end

