class TraitDisminuido < Trait

  def initialize(un_trait, *selectores_a_ignorar)
    super()
    @trait = un_trait
    @selectores_ignorados = [selectores_a_ignorar].flatten
  end

  def selectores_disponibles
    @trait.selectores_disponibles - @selectores_ignorados
  end

  def definicion(selector)
    #Para dar consistencia al modelo no deberia devolver un metodo si se le pide de un selector ignorado
    @trait.definicion(selector)
  end

  def selectores_requeridos
    @trait.selectores_requeridos
  end

  def metodos
    @trait.metodos - metodos_ignorados
  end

  def selectores_conflictivos
    @trait.selectores_conflictivos - @selectores_ignorados
  end

  private

  def metodos_ignorados
    @trait.metodos.select {|metodo| @selectores_ignorados.include? metodo.name}
    #Me genera dudas enviar el mensaje name ¿Deberia ser una definicion de metodo al que mande el mensaje "metodo"?
    # la duda surge porque parece ser una mezcla de niveles de abstraccion
  end
end

