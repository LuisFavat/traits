class TraitDisminuido < TraitAbstracto
  def initialize(un_trait, *un_ingnorar_simbolos)
    super()
    @trait = un_trait
    @mensajes_ignorados = [un_ingnorar_simbolos].flatten
  end

  def selectores_disponibles
    @trait.selectores_disponibles - selectores_ignorados
  end

  def selectores_requeridos
    @trait.selectores_requeridos
  end

  def tiene_requeridos?
    @trait.tiene_requeridos?
  end

  def selectores_ignorados
    @trait.selectores_ignorados + @mensajes_ignorados
  end

  def metodos
    @trait.metodos
  end

  def metodo(un_mensaje)
    @trait.metodo(un_mensaje)
  end
end

