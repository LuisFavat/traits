class TraitCompuesto < TraitAbstracto

  def initialize(un_trait_a, un_trait_b)
    super()
    @trait_a = un_trait_a
    @trait_b = un_trait_b
  end

  def selectores_disponibles
    @trait_a.selectores_disponibles + @trait_b.selectores_disponibles
  end

  def selectores_ignorados
    @trait_a.selectores_ignorados + @trait_b.selectores_ignorados
  end

  def selectores_requeridos
    requeridos_insatisfechos_a = @trait_a.selectores_requeridos - @trait_b.selectores_disponibles
    requeridos_insatisfechos_b = @trait_b.selectores_requeridos - @trait_a.selectores_disponibles
    requeridos_insatisfechos_a + requeridos_insatisfechos_b
  end

  def metodos
    @trait_a.metodos + @trait_b.metodos
  end

  def metodo(un_selector)
    # TODO aca puede haber conflictos??? como se resuelve? le paso el trait del que quiero el metodo???
    metodo = @trait_a.metodo(un_selector)
    if metodo.nil?
      metodo = @trait_b.metodo(un_selector)
    end
    metodo
  end

  def comprobar_conflictos
    selectores_conflictivos = @trait_a.selectores_disponibles.intersection(@trait_b.selectores_disponibles)
    hay_conflicto = false

    unless selectores_conflictivos.empty?
      selectores_conflictivos.each do |selector|
        hay_conflicto ||= (@trait_a.metodo(selector) != @trait_b.metodo(selector))
      end

      if hay_conflicto
        # TODO mostrar los nombres de los traits
        raise "Conflicto entre traits"
      end
    end
  end

end

