class TraitAbstracto


  def aplicarse_en(una_clase)
    comprobar_conflictos

    selectores_sin_conflicto(una_clase).each do |selector|
      una_clase.define_method(selector, metodo(selector))
    end
  end

  def +(un_trait)
    TraitCompuesto.new(self, un_trait)
  end

  def -(un_symbol_method)
    # TODO ver si existe el selector que es pasa como argumento
    TraitDisminuido.new(self, *un_symbol_method)
  end

  def ==(un_trait)
    # TODO manejar el caso de cuando se compara un objeto que no sea un trait
    selectores_disponibles == un_trait.selectores_disponibles &&
      selectores_requeridos == un_trait.selectores_requeridos &&
      metodos == un_trait.metodos
  end

  def selectores_disponibles
    raise NotImplementedError
  end

  def selectores_ignorados
    raise NotImplementedError
  end

  def selectores_requeridos
    raise NotImplementedError
  end

  def <<(hash_de_alias)

  end

  def comprobar_conflictos
    nil
  end

  protected
  def selectores_sin_conflicto(una_clase)
    selectores_disponibles - una_clase.instance_methods
  end
end
