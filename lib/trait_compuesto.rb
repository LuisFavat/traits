class TraitCompuesto < TraitAbstracto

  def initialize(un_trait_a, un_trait_b)
    super()
    @trait_a = un_trait_a
    @trait_b = un_trait_b
  end

  def selectores_disponibles
    @trait_a.selectores_disponibles + @trait_b.selectores_disponibles
  end

  def metodos
    @trait_a.metodos + @trait_b.metodos
  end

  def selectores_requeridos
    @trait_a.selectores_requeridos + @trait_b.selectores_requeridos
  end

  def tiene_requeridos?
    !(selectores_requeridos - selectores_disponibles).empty?
  end

  def metodo(selector)
    return @trait_a.metodo(selector) if @trait_a.define? selector

    @trait_b.metodo(selector)
  end

  def tiene_conflicto?
    !selectores_conflictivos.empty? || @trait_a.tiene_conflicto? || @trait_b.tiene_conflicto?
  end

  def selectores_conflictivos
    @trait_a.selectores_disponibles.intersection @trait_b.selectores_disponibles
  end
end

