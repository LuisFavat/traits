class ConvertidorSelectorAlias

  def initialize(hash_alias)
    @selectores_a_alias = hash_alias
    @alias_a_selectores = {}
    alias_a_selectores(hash_alias)
  end

  def contiene?(un_alias)
    @alias_a_selectores.keys.include?(un_alias)
  end

  def alias_a_selector(un_alias)
    @alias_a_selectores[un_alias]
  end

  def todos_los_alias
    @alias_a_selectores.keys
  end

  private

  def alias_a_selectores(hash)
    hash.each do |un_selector, un_alias|
      @alias_a_selectores[un_alias] = un_selector
    end
  end
end
