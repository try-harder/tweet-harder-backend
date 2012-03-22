# encoding: UTF-8

require 'minitest/autorun'
require '../../lib/sequel_store'


Encoding.default_external = Encoding::UTF_8 if defined? Encoding

class DBStoreTest < MiniTest::Unit::TestCase

  def setup
    @store = SequelStore.new
  end

  def test_get_term
    assert_equal "cat", @store.get_term(333)
  end

  def test_get_term_fail
    refute_equal "cat", @store.get_term(444)
  end

  def test_get_id
    assert_equal 333, @store.get_id("cat")
  end

  def test_get_id_fail
    refute_equal 333, @store.get_id("dog")
  end

  def test_get_id_creates_new_id
    new_id = @store.get_id("mousey")
    term = @store.get_term(new_id)
    assert_equal "mousey", term
  end

end
