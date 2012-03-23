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

  def test_get_missing_term
    refute_equal "cat", @store.get_term(444)
  end

  def test_get_id
    assert_equal 333, @store.get_id("cat")
  end

  def test_get_id_fail
    refute_equal 333, @store.get_id("dog")
  end

  def test_get_missing_id_returns_nil
    assert_nil @store.get_id("missing")
  end

  def test_get_missing_term_returns_nil
    assert_nil @store.get_term(2048)
  end

  def test_add_term
    id = @store.add_term("mousey")
    term = @store.get_term(id)
    assert_equal "mousey", term
  end

  def test_add_existing_term_raises
    assert_raises(Sequel::DatabaseError) do
      @store.add_term("mousey")
      @store.add_term("mousey")
    end
  end

end
