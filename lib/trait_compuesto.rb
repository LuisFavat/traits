class TraitCompuesto
  def initialize(un_trait_a, un_trait_b)
    @trait_a = un_trait_a
    @trait_b = un_trait_b
  end

  def aplicarse_en(una_clase)
    @trait_a.aplicarse_en(una_clase)
    @trait_b.aplicarse_en(una_clase)
  end

  def restar(mensaje)
    if @trait_a.mensajes_aplicables.include?(mensaje)
      @trait_a = @trait_a.restar(mensaje)
    end
    if @trait_a.mensajes_aplicables.include?(mensaje)
      @trait_b = @trait_b.restar(mensaje)
    end
    self
  end

  def sumar(un_trait)
    TraitCompuesto.new(self, un_trait)
  end

  def mensajes_aplicables
    @trait_a.mensajes_aplicables + @trait_b.mensajes_aplicables
  end

  def tiene_requeridos?
    @trait_a.tiene_requeridos? && @trait_b.tiene_requeridos?
  end
end

