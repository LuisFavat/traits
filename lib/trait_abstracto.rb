class TraitAbstracto

  def aplicarse_en(una_clase)
    comprobar_conflictos
    selectores_sin_conflicto = (selectores_disponibles - una_clase.instance_methods)

    selectores_sin_conflicto.each do |selector|
      una_clase.define_method(selector, metodo(selector))
    end
  end

  def +(un_trait)
    TraitCompuesto.new(self, un_trait)
  end

  def -(un_symbol_method)
    TraitDisminuido.new(self, *un_symbol_method)
  end

  def <<(selector_alias)
    TraitAlias.new(self, selector_alias)
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

  def metodo(selector)
    raise NotImplementedError
  end

  def selectores_ignorados
    raise NotImplementedError
  end

  def selectores_requeridos
    raise NotImplementedError
  end

  def define?(selector)
    selectores_disponibles.include? selector
  end

  def comprobar_conflictos
    nil
  end
end
