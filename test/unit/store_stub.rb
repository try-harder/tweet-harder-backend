# encoding: UTF-8

class StoreStub

  def initialize(terms=nil)
    @terms = terms || {}
    @last_id = @terms.inject(0) do |memo, (thing, other)|
      memo > thing ? memo : thing
    end
  end
  
  def get_term(id)
    @terms[id]
  end
  
  def get_id(term)
    @terms.invert[term]
  end

  def add_term(term)
    raise '' if @terms.has_value?(term)
    @last_id = @last_id + 1
    @terms[@last_id] = term
    @last_id
  end

end