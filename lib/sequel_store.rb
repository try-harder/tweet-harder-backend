require 'sequel'

Encoding.default_external = Encoding::UTF_8 if defined? Encoding

class SequelStore

  def initialize(db=nil)
    db ||= Sequel.sqlite # default to sqlite3 in-memory database
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