require 'diccionario_selectores'

class Trait < TraitAbstracto

  # metodos de clase
  def self.definir_comportamiento(&bloque_de_definiciones)

    proveedor_comportamiento = Module.new {

      @selectores_requeridos = []

      def self.requiere(*un_selector)
        @selectores_requeridos << un_selector
        @selectores_requeridos.flatten!
      end

      def self.selectores_requeridos
        @selectores_requeridos
      end
    }
    proveedor_comportamiento.module_exec(&bloque_de_definiciones)

    diccionario_selectores = DiccionarioSelectores.new
    proveedor_comportamiento.instance_methods(false).each do |selector|
      diccionario_selectores.agregar(proveedor_comportamiento.instance_method(selector))
    end
    new(diccionario_selectores, proveedor_comportamiento.selectores_requeridos)
  end
  
  # metodos de instancia
  def initialize(diccionario_selectores, selectores_requeridos = [])
    super()
    @diccionario_selectores = diccionario_selectores
    @selectores_requeridos = selectores_requeridos
  end

  def <<(selector_alias)
    TraitAlias.new(self, selector_alias)
  end

  def selectores_disponibles
    @diccionario_selectores.selectores
  end

  def selectores_requeridos
    @selectores_requeridos.to_set
  end

  def tiene_requeridos?
    !@selectores_requeridos.empty?
  end

  def tiene_conflicto?
    false
  end

  def selectores_ignorados
    []
  end

  def metodos
    @diccionario_selectores.metodos
  end

  def metodo(selector)
    @diccionario_selectores.metodo_de(selector)
  end

  private

  def mensajes_en_comun(una_clase)
    symbol_methods_class = una_clase.instance_methods
    symbol_methods_trait = @diccionario_selectores.keys
    symbol_methods_class.intersection(symbol_methods_trait)
  end

end
