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

  def selectores_ignorados
    @trait_a.selectores_ignorados + (@trait_b.selectores_ignorados.union)
  end

  def metodo(selector)
    raise SelectorNoDefinido unless define? selector
    return @trait_a.metodo(selector) if @trait_a.define? selector
    return @trait_b.metodo(selector) if @trait_b.define? selector
  end

  def comprobar_conflictos
    mensajes_conflictivos = @trait_a.selectores_disponibles.intersection(@trait_b.selectores_disponibles)
    unless mensajes_conflictivos.empty?
      # TODO mostrar los nombres de los traits
      raise "Conflicto entre traits"
    end

    @trait_a.comprobar_conflictos
    @trait_b.comprobar_conflictos
    nil
  end
end

