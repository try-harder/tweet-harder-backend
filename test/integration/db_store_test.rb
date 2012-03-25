require 'minitest/autorun'
require_relative '../../lib/sequel_store'

class DBStoreTest < MiniTest::Unit::TestCase

  def setup
    @store = SequelStore.new
  end

  def test_get_missing_id_returns_nil
    assert_nil @store.get_id("missing")
  end

  def test_get_missing_term_returns_nil
    assert_nil @store.get_term(2048)
  end

  def test_add_term
    refute_nil @store.add_term("mousey")
  end

  def test_added_term_exists
    id = @store.add_term("mousey")
    term = @store.get_term(id)
    assert_equal "mousey", term
  end

  def test_adding_existing_term_raises
    assert_raises(Sequel::DatabaseError) do
      @store.add_term("mousey")
      @store.add_term("mousey")
    end
  end

end
