require 'trait_disminuido'
require 'trait_compuesto'

class Trait
  #metodos de clase
  def self.definir_metodos(&bloque_de_metodos)

    extraccion = proc {

      @mensajes_requeridos = []

      def self.requiere(*un_mensaje)
        @mensajes_requeridos << un_mensaje
        @mensajes_requeridos = @mensajes_requeridos.flatten
      end

      def self.mensajes_requeridos
        @mensajes_requeridos
      end
    }

    modulo_con_metodos = Module.new &extraccion
    modulo_con_metodos.class_exec(&bloque_de_metodos)

    hash_de_metodos = {}
    modulo_con_metodos.instance_methods(false).each do |mensaje|
      hash_de_metodos[mensaje] = modulo_con_metodos.instance_method(mensaje)
    end
    new(hash_de_metodos, modulo_con_metodos.mensajes_requeridos)
  end
  
  #metodos de instancia
  def initialize(unos_metodos, unos_mensajes_requeridos = [])
    @hash_de_metodos = unos_metodos
    @mensajes_requeridos = unos_mensajes_requeridos
  end

  def aplicarse_en(una_clase, mensajes_ignorados = [])
    comprobar_requerimientos(una_clase)
    puts
    mensajes_a_ignorar = mensajes_en_comun(una_clase) + mensajes_ignorados
    mensajes_a_aplicar = @hash_de_metodos.keys - mensajes_a_ignorar
    mensajes_a_aplicar.each{ |mensaje|
          una_clase.define_method(mensaje, @hash_de_metodos[mensaje])
        }
  end

  def restar(un_symbol_method)
    TraitDisminuido.new(self, un_symbol_method)
  end

  def sumar(un_trait)
    TraitCompuesto.new(self , un_trait)
  end

  def mensajes_disponibles
    @hash_de_metodos.keys
  end

  def tiene_requeridos?
    @mensajes_requeridos.empty?
  end

  def mensajes_requeridos
    @mensajes_requeridos.clone
  end

  private
  def mensajes_en_comun(una_clase)
    symbol_methods_class = una_clase.instance_methods
    symbol_methods_trait = @hash_de_metodos.keys
    symbol_methods_class.intersection(symbol_methods_trait)
  end

  def comprobar_requerimientos(una_clase)
    mensajes_en_clase = una_clase.instance_methods
    requerimientos = @mensajes_requeridos - mensajes_en_clase
    puts "requerimientos"
    puts requerimientos.empty?
    if !requerimientos.empty?
      raise("Faltan los siguientes metoddos requeridos: #{requerimientos}")
    end
  end

end


