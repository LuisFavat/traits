require 'trait_abstracto'
require 'trait_disminuido'
require 'trait_compuesto'
require 'interfaz_de_usuario'
require 'trait_alias'
require 'convertidos_selector_alias'

class Trait < TraitAbstracto

  # metodos de clase
  def self.definir_comportamiento(&bloque_de_metodos)

    modulo_con_metodos = Module.new {

      @selectores_requeridos = []

      def self.requiere(*un_selector)
        @selectores_requeridos << un_selector
        @selectores_requeridos.flatten!
      end

      def self.selectores_requeridos
        @selectores_requeridos
      end
    }
    modulo_con_metodos.class_exec(&bloque_de_metodos)

    hash_de_metodos = {}
    modulo_con_metodos.instance_methods(false).each do |selector|
      hash_de_metodos[selector] = modulo_con_metodos.instance_method(selector)
    end
    new(hash_de_metodos, modulo_con_metodos.selectores_requeridos)
  end
  
  # metodos de instancia
  def initialize(unos_metodos, unos_selectores_requeridos = [])
    super()
    @hash_de_metodos = unos_metodos
    @selectores_requeridos = unos_selectores_requeridos
  end

  def selectores_disponibles
    @hash_de_metodos.keys.to_set
  end

  def selectores_ignorados
    []
  end

  def selectores_requeridos
    @selectores_requeridos.clone.to_set
  end

  def metodos
    @hash_de_metodos.values.to_set
  end

  def metodo(un_selector)
    @hash_de_metodos[un_selector]
  end

  def tiene_requeridos?
    !@selectores_requeridos.empty?
  end

  private

  def comprobar_requerimientos(una_clase)
    selectores_de_instancia = una_clase.instance_methods
    requerimientos = @selectores_requeridos - selectores_de_instancia

    unless requerimientos.empty?
      raise("Faltan los siguientes metoddos requeridos: #{requerimientos}")
    end
  end

end
