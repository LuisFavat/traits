class TraitAlias < TraitAbstracto

  def initialize(trait, selector_alias)
    super()
    @trait = trait
    @selector_alias = selector_alias
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

end
