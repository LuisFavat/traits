require 'trait_con_conflicto_error'

class TraitAbstracto

  def aplicarse_en(una_clase)
    comprobar_conflictos

    selectores_aplicables(una_clase).each do |selector|
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
    #return false unless un_trait.kind_of? TraitAbstracto
    selectores_disponibles == un_trait.selectores_disponibles &&
      selectores_requeridos == un_trait.selectores_requeridos &&
      metodos == un_trait.metodos
  end

  def define?(selector)
    selectores_disponibles.include? selector
  end

  def selectores_disponibles
    raise NotImplementedError
  end

  def metodo(selector)
    raise NotImplementedError
  end

  def selectores_requeridos
    raise NotImplementedError
  end

  def tiene_conflicto?
    raise NotImplementedError
  end

  private

  def comprobar_conflictos
    raise TraitConConflictoError if tiene_conflicto?
  end

  def selectores_aplicables(una_clase)
    selectores_disponibles - una_clase.instance_methods
  end

end
