class TraitDisminuido < TraitAbstracto

  def initialize(un_trait, *selectores_a_ignorar)
    super()
    @trait = un_trait
    @selectores_ignorados = [selectores_a_ignorar].flatten
  end

  def selectores_disponibles
    @trait.selectores_disponibles - @selectores_ignorados
  end

  def selectores_requeridos
    @trait.selectores_requeridos
  end

  def tiene_requeridos?
    @trait.tiene_requeridos?
  end

  def metodos
    @trait.metodos
  end

  def metodo(selector)
    @trait.metodo(selector)
  end
end

