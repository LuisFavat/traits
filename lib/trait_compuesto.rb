class TraitCompuesto < TraitAbstracto

  def initialize(un_trait_a, un_trait_b)
    super()
    @trait_a = un_trait_a
    @trait_b = un_trait_b
  end

  def mensajes_disponibles
    @trait_a.mensajes_disponibles + @trait_b.mensajes_disponibles
  end

  def metodos
    @trait_a.metodos + @trait_b.metodos
  end

  def mensajes_requeridos
    @trait_a.mensajes_requeridos + @trait_b.mensajes_requeridos
  end

  def tiene_requeridos?
    !(mensajes_requeridos - mensajes_disponibles).empty?
  end

  def mensajes_ignorados
    @trait_a.mensajes_ignorados + (@trait_b..mensajes_ignorados.union)
  end

  def metodo(un_mensaje)
    metodo = @trait_a.metodo(un_mensaje)
    if metodo.nil?
      metodo = @trait_b.metodo(un_mensaje)
    end
    metodo
  end

  def comprobar_conflictos
    mensajes_conflictivos = @trait_a.mensajes_disponibles.intersection(@trait_b.mensajes_disponibles)
    unless mensajes_conflictivos.empty?
      # TODO mostrar los nombres de los traits
      raise "Conflicto entre traits"
    end
    @trait_a.comprobar_conflictos
    @trait_b.comprobar_conflictos
    nil
  end
end

