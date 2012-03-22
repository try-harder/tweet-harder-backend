# encoding: UTF-8

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