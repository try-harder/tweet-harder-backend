# encoding: UTF-8

require 'minitest/autorun'
require 'mysql'
require 'sequel'

class SequelStore

  def initialize
    db = Sequel.sqlite # memory database
    db.create_table :terms do
      primary_key :id
      String :term
    end
    @terms = db[:terms]
    @terms.insert(id: 333, term: "cat")
    @terms.insert(id: 444, term: "dog")
  end

  def get_term(id)
    @terms[:id => id][:term]
  end
  
  def get_id(term)
    row = @terms[:term => term]
    if row
      row[:id]
    else
      @terms.insert(term: term)
    end 
  end

end

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
