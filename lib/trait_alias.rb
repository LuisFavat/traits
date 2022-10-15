class TraitAlias < TraitAbstracto

  def initialize(un_trait, unos_alias)
    @trait = un_trait
    @alias_selectores = conmutar_keys_y_values(unos_alias)
  end

  def selectores_disponibles
    @trait.selectores_disponibles + todos_los_alias
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
    if @alias_selectores.keys.include?(un_alias)
      selector = alias_a_selector(un_alias)
    else
      selector = un_alias
    end
    @trait.metodo(selector)
  end

  def comprobar_conflictos
    @trait.comprobar_conflictos
  end

  def contiene?(un_alias)
    @alias_selectores.keys.include?(un_alias)
  end

  def alias_a_selector(un_alias)
    @alias_selectores[un_alias]
  end

  def todos_los_alias
    @alias_selectores.keys
  end

  private

  def conmutar_keys_y_values(hash)
    alias_conmutado = {}
    hash.each do |un_selector, un_alias|
      alias_conmutado[un_alias] = un_selector
    end
    alias_conmutado
  end

end
