require 'trait_abstracto'
require 'trait_disminuido'
require 'trait_compuesto'
require 'interfaz_de_usuario'
require 'trait_alias'


class Trait < TraitAbstracto

  # metodos de clase
  def self.debe(&bloque_de_metodos)
    modulo_plus = requerimientos_en_modulos
    hash_de_metodos = extraer_metodos(modulo_plus, &bloque_de_metodos)
    Trait.new(hash_de_metodos, modulo_plus.selectores_requeridos)
  end

  def self.requerimientos_en_modulos()
    Module.new {
      @selectores_requeridos = []

      def self.requiere(*un_selector)
        @selectores_requeridos << un_selector
        @selectores_requeridos.flatten!
      end

      def self.selectores_requeridos
        @selectores_requeridos
      end
    }
  end

  def self.extraer_metodos(modulo_con_metodos, &bloque_de_metodos)
    modulo_con_metodos.class_exec(&bloque_de_metodos)

    hash_de_metodos = {}
    modulo_con_metodos.instance_methods(false).each do |selector|
      hash_de_metodos[selector] = modulo_con_metodos.instance_method(selector)
    end
    hash_de_metodos
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

  def comprobar_conflictos
  end

end
