# encoding: UTF-8

class Translator
  
  # ("" << 333).ord

  def initialize(store)
    @store = store
  end

  def encode(term)
    "" << @store.get_id(term)
  end

  def encode_all(terms)
    (terms.split.map{|term| encode(term)}).join
  end

  def decode(char)
    @store.get_term(char.ord)
  end

  def decode_all(chars)
    (chars.split("").map {|char| decode(char)}).join(" ")
  end

end

