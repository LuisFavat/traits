class MetodoTrait

  def initialize(metodo)
    @metodo = metodo
  end

  def selector
    @metodo.name
  end

  def metodo
    @metodo
  end
end
