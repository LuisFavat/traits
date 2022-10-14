class TraitAlias < TraitAbstracto

  def initialize(trait, selector_alias)
    super()
    @trait = trait
    @selector_alias = selector_alias
  end

  def selectores_disponibles
    @trait.selectores_disponibles + @selector_alias.values
  end

  def metodo(selector)
    return @trait.metodo selector unless es_alias? selector
    @trait.metodo(@selector_alias.key selector)
  end

  def selectores_ignorados
    raise NotImplementedError
  end

  def selectores_requeridos
    raise NotImplementedError
  end

  private
  def es_alias?(selector)
    @selector_alias.value? selector
  end
end
