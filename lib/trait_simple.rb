require 'trait'
require 'trait_disminuido'
require 'trait_compuesto'
require 'interfaz_de_usuario'
require 'trait_alias'

class TraitSimple < Trait

  class << self
    def debe(&bloque_de_metodos)
      modulo_plus = requerimientos_en_modulos
      hash_de_metodos = extraer_metodos(modulo_plus, &bloque_de_metodos)
      TraitSimple.new(hash_de_metodos, modulo_plus.selectores_requeridos)
    end

    def requerimientos_en_modulos()
      Module.new {
        @selectores_requeridos = Set.new

        def self.requiere(*selectores)
          @selectores_requeridos.add(*selectores)
        end

        def self.selectores_requeridos
          @selectores_requeridos
        end
      }
    end

    def extraer_metodos(modulo_con_metodos, &bloque_de_metodos)
      modulo_con_metodos.class_exec(&bloque_de_metodos)

     modulo_con_metodos.instance_methods(false).reduce({}) do |hash_de_metodos, selector|
        hash_de_metodos.merge(selector => modulo_con_metodos.instance_method(selector))
      end
    end
  end
  
  def initialize(unos_metodos, unos_selectores_requeridos = [])
    super()
    @hash_de_metodos = unos_metodos
    @selectores_requeridos = unos_selectores_requeridos
  end

  def selectores_disponibles
    @hash_de_metodos.keys.to_set
  end

  def selectores_requeridos
    @selectores_requeridos.clone
  end

  def metodos
    @hash_de_metodos.values.to_set
  end

  def metodos_para(un_selector)
    Set.new(@hash_de_metodos.key?(un_selector) ? [@hash_de_metodos[un_selector]] : [])
  end

  def comprobar_conflictos
  end
end
