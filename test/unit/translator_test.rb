# encoding: UTF-8
require './support/env'
require '../../lib/translator'

Encoding.default_external = Encoding::UTF_8 if defined? Encoding

class TweetTest < MiniTest::Unit::TestCase

  def setup
    store = StoreStub.new({
      "cat" => 333,
      "dog" => 444
    })
    @translator = Translator.new(store)
  end

  def test_encode_word
    assert_equal "ō", @translator.encode("cat")
  end

  def test_encode_word_fail
    refute_equal "ō", @translator.encode("dog")
  end

  def test_decode_word
    assert_equal "cat", @translator.decode("ō")
  end
  
  def test_decode_word_fail
    refute_equal "cat", @translator.decode("Ƽ")
  end

  def test_encode_words
    assert_equal "ōƼ", @translator.encode_all("cat dog")
  end

  def test_encode_words_fail
    refute_equal "ōƼ", @translator.encode_all("dog cat")
  end

  def test_decode_words
    assert_equal "cat dog", @translator.decode_all("ōƼ")
  end

  def test_decode_words_fail
    refute_equal "cat dog", @translator.decode_all("Ƽō")
  end

end
