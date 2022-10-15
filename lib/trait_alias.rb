class TraitAlias < TraitAbstracto

  def initialize(trait, selector_alias)
    super()
    @trait = trait
    @selector_alias = selector_alias
  end

  def selectores_disponibles
    @trait.selectores_disponibles + aliases
  end

  def metodo(selector)
    return @trait.metodo selector unless es_alias? selector
    @trait.metodo(@selector_alias.key selector)
  end

  def selectores_requeridos
    @trait.selectores_requeridos - aliases
  end

  def metodos
    @trait.metodos
  end

  def selectores_conflictivos
    @trait.selectores_conflictivos
  end

  private

  #Nombre horrible, pensar alguno mejor
  def aliases
    @selector_alias.values
  end

  def es_alias?(selector)
    @selector_alias.value? selector
  end
end
