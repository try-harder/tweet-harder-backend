# encoding: UTF-8

class StoreStub

  def initialize(terms)
    @terms = terms
  end
  
  def get_term(id)
    @terms.invert[id]
  end
  
  def get_id(term)
    @terms[term]
  end

end