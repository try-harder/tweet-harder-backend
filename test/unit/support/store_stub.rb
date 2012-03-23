# encoding: UTF-8

class StoreStub

  def initialize(terms)
    @terms = terms
  end
  
  def get_term(id)
    @terms[id]
  end
  
  def get_id(term)
    @terms.invert[term]
  end

end