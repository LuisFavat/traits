class TraitAlias < Trait

  def initialize(trait, selector_alias)
    super()
    @trait = trait
    @selector_alias = selector_alias
  end

  def selectores_disponibles
    @trait.selectores_disponibles + aliases
  end

  def definicion(selector)
    return @trait.definicion selector unless es_alias? selector
    @trait.definicion(@selector_alias.key selector)
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
