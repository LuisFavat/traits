class TraitCompuesto < TraitAbstracto
  def initialize(un_trait_a, un_trait_b)
    @trait_a = un_trait_a
    @trait_b = un_trait_b
  end

  def aplicarse_en(una_clase)
    @trait_a.aplicarse_en(una_clase)
    @trait_b.aplicarse_en(una_clase)
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
    @trait_a.tiene_requeridos?  || @trait_b.tiene_requeridos?
  end

  def mensajes_ignorados
    @trait_a.mensajes_ignorados + (@trait_b..mensajes_ignorados.union)
  end
end

