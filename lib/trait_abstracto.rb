class TraitAbstracto

  def sumar(un_trait)
    TraitCompuesto.new(self , un_trait)
  end

  def restar(un_symbol_method)
    TraitDisminuido.new(self, un_symbol_method)
  end
end
