class TraitCompuesto < Trait

  def initialize(un_trait_a, un_trait_b)
    super()
    @trait_a = un_trait_a
    @trait_b = un_trait_b
  end

  #Este metodo se sobre-escribe porque la logica en la clase abstracta no alcanza para el calculo de requeridos para
  # los traits compuestos ya que se puede resolver un requerimiento al componer traits
  def tiene_requeridos?
    !(selectores_requeridos - selectores_disponibles).empty?
  end

  #Caso similar a "tiene_requeridos" ya que se pueden estar componiendo con traits que ya tienen conflictos o bien
  # generarse un conflicto a partir de la composicion mencionada
  def tiene_conflicto?
    super() || @trait_a.tiene_conflicto? || @trait_b.tiene_conflicto?
  end

  def selectores_disponibles
    @trait_a.selectores_disponibles + @trait_b.selectores_disponibles
  end

  def metodo(selector)
    return @trait_a.metodo(selector) if @trait_a.define? selector

    @trait_b.metodo(selector)
  end

  def selectores_requeridos
    @trait_a.selectores_requeridos + @trait_b.selectores_requeridos
  end

  def metodos
    @trait_a.metodos + @trait_b.metodos
  end

  def selectores_conflictivos
    @trait_a.selectores_disponibles.intersection @trait_b.selectores_disponibles
  end
end

