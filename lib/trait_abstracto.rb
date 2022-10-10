class TraitAbstracto

  def initialize
    @alias = {}
  end

  def aplicarse_en(una_clase)
    comprobar_conflictos
    mensajes_sin_conflicto = (mensajes_disponibles - una_clase.instance_methods)

    mensajes_sin_conflicto.each do |mensaje|
      una_clase.define_method(mensaje, metodo(mensaje))
    end
    @alias.each { |mensaje, apodo|
      una_clase.define_method(apodo, metodo(mensaje))
    }
  end

  def +(un_trait)
    TraitCompuesto.new(self, un_trait)
  end

  def -(un_symbol_method)
    TraitDisminuido.new(self, *un_symbol_method)
  end

  def ==(un_trait)
    # TODO manejar el caso de cuando se compara un objeto que no sea un trait
    mensajes_disponibles == un_trait.mensajes_disponibles &&
      mensajes_requeridos == un_trait.mensajes_requeridos &&
      metodos == un_trait.metodos
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

  def <<(hash_de_alias)
    hash_de_alias.each do |mensaje, apodo|
      @alias[mensaje] = apodo
    end
    self
  end

  def comprobar_conflictos
    nil
  end
end
