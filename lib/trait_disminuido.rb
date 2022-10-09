class TraitDisminuido < TraitAbstracto
  def initialize(un_trait, *un_ingnorar_simbolos)
    super()
    @trait = un_trait
    @mensajes_ignorados = [un_ingnorar_simbolos].flatten
  end

  def mensajes_disponibles
    @trait.mensajes_disponibles - mensajes_ignorados
  end

  def mensajes_requeridos
    @trait.mensajes_requeridos
  end

  def tiene_requeridos?
    @trait.tiene_requeridos?
  end

  def mensajes_ignorados
    @trait.mensajes_ignorados + @mensajes_ignorados
  end

  def metodos
    @trait.metodos
  end

  def metodo(un_mensaje)
    @trait.metodo(un_mensaje)
  end
end

