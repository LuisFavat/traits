class Trait

  def aplicarse_en(una_clase)
    comprobar_conflictos

    selectores_sin_conflicto(una_clase).each do |selector|
      ms = metodos_para(selector)
      una_clase.define_method(selector, ms.first)
    end
  end

  def +(un_trait)
    TraitCompuesto.new(self, un_trait)
  end

  def -(un_selector)

    selectores = [un_selector].flatten
    selectores.each do |selector|
      unless selectores_disponibles.include?(selector)
        raise TraitDisminuido.mensaje_de_error_en_resta
      end
    end

    TraitDisminuido.new(self, selectores)
  end

  def <<(hash_de_alias)
    unos_alias = hash_de_alias.values
    if selectores_requeridos.any?{|requerido| unos_alias.include?requerido}
      raise "El alias no puede ser igual a un selector requerido"
    end
    if selectores_disponibles.any?{|requerido| unos_alias.include?requerido}
      raise "El alias no puede ser igual a un selector disponible"
    end

    TraitAlias.new(self, hash_de_alias)
  end

  def ==(un_trait)
    unless un_trait.class.superclass == Trait
      return false
    end
    selectores_disponibles == un_trait.selectores_disponibles &&
    selectores_requeridos == un_trait.selectores_requeridos &&
    metodos == un_trait.metodos
  end

  def selectores_disponibles
    raise NotImplementedError
  end

  def selectores_requeridos
    raise NotImplementedError
  end

  def metodos
    raise NotImplementedError
  end

  def metodos_para(un_selector)
    raise NotImplementedError
  end

  def comprobar_conflictos
    raise NotImplementedError
  end

  def selectores_sin_conflicto(una_clase)
    selectores_disponibles - una_clase.instance_methods
  end

end
