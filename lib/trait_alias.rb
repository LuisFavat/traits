class TraitAlias < TraitAbstracto

  def initialize(un_trait, unos_alias)
    super()
    @trait = un_trait
    @alias_y_selectores = ConvertidorSelectorAlias.new(unos_alias)
  end

  def selectores_disponibles
    @trait.selectores_disponibles + @alias_y_selectores.todos_los_alias
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

  def metodo(un_alias)
    if @alias_y_selectores.contiene?(un_alias)
      selector = @alias_y_selectores.alias_a_selector(un_alias)
    else
      selector = un_alias
    end
    @trait.metodo(selector)
  end

end
