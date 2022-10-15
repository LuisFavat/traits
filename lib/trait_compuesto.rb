class TraitCompuesto < Trait

  def comprobar_conflictos
    @trait.comprobar_conflictos
  end

  def initialize(un_trait_a, un_trait_b)
    super()
    @trait_a = un_trait_a
    @trait_b = un_trait_b
  end

  def selectores_disponibles
    @trait_a.selectores_disponibles + @trait_b.selectores_disponibles
  end

  def selectores_requeridos
    suma_de_requeridos = @trait_a.selectores_requeridos + @trait_b.selectores_requeridos
    suma_de_requeridos - selectores_disponibles
  end

  def metodos
    @trait_a.metodos + @trait_b.metodos
  end

  def metodos_para(un_selector)
    # TODO aca puede haber conflictos??? como se resuelve? le paso el trait del que quiero el metodo???
    metodo = @trait_a.metodos_para(un_selector).first
    if metodo.nil?
      metodo = @trait_b.metodos_para(un_selector).first
    end
    Set.new([metodo])

    @trait_a.metodos_para(un_selector).union(
      @trait_b.metodos_para(un_selector)
    )
  end

  def comprobar_conflictos
    selectores_potencialmente_conflictivos = @trait_a.selectores_disponibles.intersection(@trait_b.selectores_disponibles)

    unless selectores_potencialmente_conflictivos.empty?
      hay_conflicto = selectores_potencialmente_conflictivos.any? do |selector|
        @trait_a.metodos_para(selector).union(@trait_b.metodos_para(selector)).size > 1
      end

      if hay_conflicto
        # TODO mostrar los nombres de los traits
        raise "Conflicto entre traits"
      end
    end
  end

end

