# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/translator'
require_relative '../../lib/sequel_store'

class TweetTest < MiniTest::Unit::TestCase

  def setup
    @store = SequelStore.new
    @translator = Translator.new(@store)
  end

  def test_encode_unknown_term
    refute_nil @translator.encode("cat")
  end

  def test_encode_known_term
    char = "" << @store.add_term("dog")
    assert_equal char, @translator.encode("dog")
  end

  def test_decode_unknown_term
    assert_nil @translator.decode("ō")
  end
  
  def test_decode_known_term
    char = "" << @store.add_term("cat")
    assert_equal "cat", @translator.decode(char)
  end

  def test_encode_unknown_terms
    refute_nil @translator.encode_all("cat dog")
  end

  def test_encode_known_terms
    char1 = "" << @store.add_term("dog")
    char2 = "" << @store.add_term("cat")
    assert_equal char1 + char2, @translator.encode_all("dog cat")
  end

  def test_decode_unknown_terms
    assert_empty @translator.decode_all("ōƼ")
  end

  def test_decode_known_terms
    char1 = "" << @store.add_term("dog")
    char2 = "" << @store.add_term("cat")
    assert_equal "dog cat", @translator.decode_all(char1 + char2)
  end

end
