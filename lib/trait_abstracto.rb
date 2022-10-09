class TraitAbstracto

  def aplicarse_en(una_clase)
    (self.mensajes_disponibles - una_clase.instance_methods).each { |mensaje| una_clase.define_method(mensaje, self.metodo_llamado(mensaje))
    }
  end

  def +(un_trait)
    TraitCompuesto.new(self, un_trait)
  end

  def -(un_symbol_method)
    TraitDisminuido.new(self, *un_symbol_method)
  end

  def ==(unTrait)
    self.mensajes_disponibles == unTrait.mensajes_disponibles &&
      self.mensajes_requeridos == unTrait.mensajes_requeridos &&
      self.metodos == unTrait.metodos
  end

  def mensajes_disponibles
    raise NotImplementedError
  end

  def mensajes_ignorados
    raise NotImplementedError
  end

  def mensajes_requeridos
    raise NotImplementedError
  end
end
