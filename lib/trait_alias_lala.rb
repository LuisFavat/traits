class TraitAliasLala < TraitAbstracto

  def initialize(un_trait, unos_alias)
    super()
    @trait = un_trait
    @alias = unos_alias
  end

  def selectores_disponibles
    @trait.selectores_disponibles + @alias.keys
  end

  def selectores_ignorados
    @trait.selectores_ignorados
  end

  def selectores_requeridos
    @trait.selectores_requeridos
  end

  def metodos
    @trait.metodos
  end

  def metodo(un_selector)
    @trait.metodo(un_selector)
  end

end
