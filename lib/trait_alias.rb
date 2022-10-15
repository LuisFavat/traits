class TraitAlias < Trait

  def comprobar_conflictos
    @trait.comprobar_conflictos
  end

  def initialize(un_trait, unos_alias)
    super()
    @trait = un_trait
    @alias_selectores = conmutar_keys_y_values(unos_alias)
  end

  def selectores_disponibles
    @trait.selectores_disponibles + todos_los_alias
  end

  def selectores_requeridos
    @trait.selectores_requeridos
  end

  def metodos
    @trait.metodos
  end
  def metodos_para(un_selector)
    if @alias_selectores.keys.include?(un_selector)
      selector = alias_a_selector(un_selector)
    else
      selector = un_selector
    end
    @trait.metodos_para(selector)
  end

  def alias_a_selector(un_alias)
    @alias_selectores[un_alias]
  end

  def todos_los_alias
    @alias_selectores.keys
  end

  def comprobar_conflictos
    @trait.comprobar_conflictos
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
