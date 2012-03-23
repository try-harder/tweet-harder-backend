# encoding: UTF-8

require 'sequel'

class SequelStore

  def initialize
    db = Sequel.sqlite # memory database
    db.create_table :terms do
      primary_key :id
      String :term, unique: true
    end
    @terms = db[:terms]
    @terms.insert(id: 333, term: "cat")
    @terms.insert(id: 444, term: "dog")
  end

  def get_term(id)
    row = @terms[:id => id]
    return row[:term] if row
  end
  
  def get_id(term)
    row = @terms[:term => term]
    return row[:id] if row
  end

  def add_term(term)
    @terms.insert(term: term)
  end

end