# encoding: UTF-8

require 'sequel'

class SequelStore

  def initialize(db=nil)
    db ||= Sequel.sqlite # in-memory database
    db.create_table :terms do
      primary_key :id
      String :term, unique: true
    end
    @terms = db[:terms]
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