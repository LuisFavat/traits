class TraitCompuesto < TraitAbstracto

  def initialize(un_trait_a, un_trait_b)
    super()
    @trait_sumando_1 = un_trait_a
    @trait_sumando_2 = un_trait_b
  end

  def selectores_disponibles
    @trait_sumando_1.selectores_disponibles + @trait_sumando_2.selectores_disponibles
  end

  def selectores_ignorados
    @trait_sumando_1.selectores_ignorados + @trait_sumando_2.selectores_ignorados
  end

  def selectores_requeridos
    @trait_sumando_1.selectores_requeridos + @trait_sumando_2.selectores_requeridos
  end

  def metodos
    @trait_sumando_1.metodos + @trait_sumando_2.metodos
  end

  def metodo(un_selector)
    # TODO aca puede haber conflictos??? como se resuelve? le paso el trait del que quiero el metodo???
    metodo = @trait_sumando_1.metodo(un_selector)
    if metodo.nil?
      metodo = @trait_sumando_2.metodo(un_selector)
    end
    metodo
  end

  def tiene_requeridos?
    !(selectores_requeridos - selectores_disponibles).empty?
  end

  def comprobar_conflictos
    selectores_conflictivos = @trait_sumando_1.selectores_disponibles.intersection(@trait_sumando_2.selectores_disponibles)
    hay_conflicto = false

    unless selectores_conflictivos.empty?
      selectores_conflictivos.each do |selector|
        hay_conflicto ||= (@trait_sumando_1.metodo(selector) != @trait_sumando_2.metodo(selector))
      end

      if hay_conflicto
        # TODO mostrar los nombres de los traits
        raise "Conflicto entre traits"
      end
    end
    nil
  end
end

