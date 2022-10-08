class TraitDisminuido
  def initialize(un_trait, un_ingnorar_simbolos)
    @trait = un_trait
    @mensajes_ignorados = [un_ingnorar_simbolos].flatten
  end

  def aplicarse_en(una_clase)
    @trait.aplicarse_en(una_clase, @mensajes_ignorados)
  end

  def mensajes_aplicables
    @trait.mensajes_aplicables - @array_ignorar_symbols
  end
end

