require 'trait_con_conflicto_error'
require 'no_define_selector'

class Trait

  def aplicarse_en(una_clase)
    comprobar_conflictos

    selectores_aplicables(una_clase).each do |selector|
      una_clase.define_method(selector, metodo(selector))
    end
  end

  def +(un_trait)
    TraitCompuesto.new(self, un_trait)
  end

  def -(selector)
    raise NoDefineSelector unless define? selector
    TraitDisminuido.new(self, *selector)
  end

  def <<(selector_alias)
    TraitAlias.new(self, selector_alias)
  end

  def ==(un_trait)
    return false unless un_trait.kind_of? Trait
    selectores_disponibles == un_trait.selectores_disponibles &&
      selectores_requeridos == un_trait.selectores_requeridos &&
      metodos == un_trait.metodos
  end

  def define?(selector)
    selectores_a_verificar = [selector].flatten #esto esta asi porque se utiliza para validar la resta
    selectores_a_verificar.all? {|selector_a_verificar| selectores_disponibles.include? selector_a_verificar}
  end

  def tiene_requeridos?
    !selectores_requeridos.empty?
  end

  def tiene_conflicto?
    !selectores_conflictivos.empty?
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

  def metodos
    raise NotImplementedError
  end

  def selectores_conflictivos
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
