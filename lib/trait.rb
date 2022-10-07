# frozen_string_literal: true

class Trait
  # metodos de clase
  def self.definir_comportamiento(&bloque_definiciones)
    modulo_con_mensajes = Module.new(&bloque_definiciones)
    diccionario_de_mensajes = {}
    modulo_con_mensajes.instance_methods(false).each do |mensaje|
      diccionario_de_mensajes[mensaje] = modulo_con_mensajes.instance_method(mensaje)
    end

    new(diccionario_de_mensajes)
  end

  # metodos de instancia
  def initialize(diccionario_de_mensajes, mensajes_requeridos = [])
    @diccionario_de_mensajes = diccionario_de_mensajes
    @mensajes_requeridos = mensajes_requeridos
  end

  def diccionario_de_mensajes
    @diccionario_de_mensajes.clone
  end

  def mensajes_definidos
    @diccionario_de_mensajes.keys
  end

  def mensajes_requeridos
    @mensajes_requeridos.clone
  end

  def tiene_requeridos?
    !@mensajes_requeridos.empty?
  end

  def requiere(un_mensaje)
    @mensajes_requeridos << un_mensaje
  end

  def aplicarse_en(una_clase)
    mensajes_a_inyectar = mensajes_definidos - mensajes_en_comun(una_clase)
    mensajes_a_inyectar.each do |mensaje|
      una_clase.define_method(mensaje, @diccionario_de_mensajes[mensaje])
    end
  end

  def -(*mensajes)
    diccionario_reducido = diccionario_de_mensajes
    mensajes_a_eliminar = mensajes.flatten
    mensajes_a_eliminar.each { |mensaje| diccionario_reducido.delete mensaje}
    self.class.new(diccionario_reducido, @mensajes_requeridos)
  end

  def +(un_trait)
    TraitCompuesto.combinar(self, un_trait)
  end

  def ==(un_trait)
    (@diccionario_de_mensajes.eql? un_trait.diccionario_de_mensajes) &&
      (@mensajes_requeridos.eql? un_trait.mensajes_requeridos)
  end

  def <<(mensaje_alias)
    mensaje_alias.each { |mensaje, alias_mensaje|
      @diccionario_de_mensajes[alias_mensaje] = @diccionario_de_mensajes[mensaje]
    }
    self
  end

  private

  def mensajes_en_comun(una_clase)
    mensajes_instancia = una_clase.instance_methods
    mensajes_trait = mensajes_definidos
    mensajes_instancia.intersection(mensajes_trait)
  end
end

class TraitCompuesto < Trait
  def self.combinar(un_trait, otro_trait)
    mensajes_requeridos = un_trait.mensajes_requeridos.union(otro_trait.mensajes_requeridos)
    mensajes_definidos = un_trait.mensajes_definidos.union(otro_trait.mensajes_definidos)
    combinacion_mensajes_requeridos = mensajes_requeridos - mensajes_definidos
    diccionario_combinado = un_trait.diccionario_de_mensajes.merge otro_trait.diccionario_de_mensajes
    TraitCompuesto.new(diccionario_combinado, combinacion_mensajes_requeridos)
  end

end
