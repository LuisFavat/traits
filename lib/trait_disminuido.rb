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

  def tiene_conflicto?
    @trait.tiene_conflicto? && !son_selectores_ignorados(@trait.selectores_conflictivos)
  end

  def tiene_requeridos?
    @trait.tiene_requeridos?
  end

  def metodos
    @trait.metodos - metodos_ignorados
  end

  def metodo(selector)
    @trait.metodo(selector)
  end

  private

  def son_selectores_ignorados(selectores)
    selectores.all? {|conflictivo| @selectores_ignorados.include? conflictivo}
  end

  def metodos_ignorados
    @trait.metodos.select {|metodo| @selectores_ignorados.include? metodo.name}
  end
end

