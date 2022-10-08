class TraitAbstracto
  def +(un_trait)
    TraitCompuesto.new(self , un_trait)
  end

  def -(un_symbol_method)
    TraitDisminuido.new(self, *un_symbol_method)
  end


end
