# encoding: UTF-8

class StoreStub

  def initialize(terms)
    @terms = terms
  end
  
  def get_term(id)
    flipped_terms[id]
  end
  
  def get_id(term)
    @terms[term]
  end

  def flipped_terms
    result = {}
    @terms.each { |key, val| result[val] = key }
    result
  end
end