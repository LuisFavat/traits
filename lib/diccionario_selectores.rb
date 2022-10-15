require 'metodo_trait'

class DiccionarioSelectores

  def initialize
    @definiciones = Set.new
  end

  def agregar(metodo)
    @definiciones << MetodoTrait.new(metodo)
  end

  def selectores
    @definiciones.collect {|definicion| definicion.selector}.to_set
  end

  def metodos
    @definiciones.collect {|definicion| definicion.metodo}.to_set
  end

  def metodo_de(selector)
    @definiciones.find {|definicion| definicion.selector.eql? selector}
  end
end
