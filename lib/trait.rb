class Trait
  #metodos de clase
  def self.definir_metodos(&bloque_de_metodos)
    modulo_con_metodos = Module.new &bloque_de_metodos
    hash_de_metodos = {}
    modulo_con_metodos.instance_methods(false).each do |symbol_method|
      hash_de_metodos[symbol_method] = modulo_con_metodos.instance_method(symbol_method)
    end
    new(hash_de_metodos)
  end


  #metodos de instancia
  def initialize(un_hash_de_metodos)
    @hash_de_metodos = un_hash_de_metodos
    @mensajes_requeridos = []
  end

  def inyectarse_en(una_clase)
    mensajes_a_inyectar = @hash_de_metodos.keys - mensajes_en_comun(una_clase)
    mensajes_a_inyectar.each{ |mensaje|
          una_clase.define_method(mensaje, @hash_de_metodos[mensaje])
        }
  end

  def inyectarse_de_forma_reducida(una_clase, simbolos_a_ignorar)
    comprobar_conflicto_reducido(una_clase, simbolos_a_ignorar)
    @hash_de_metodos.each{|symbol, method|
      unless simbolos_a_ignorar.include?(symbol)
        una_clase.define_method(symbol, method)
      end
    }
  end


  def restar(un_symbol_method)
    TraitDisminuido.new(self, un_symbol_method)
  end

  def sumar(un_trait)
    TraitCompuesto.new(self , un_trait)
  end

  def metodos_disponibles
    @hash_de_metodos.keys
  end

  def requiere(un_mensaje)
    @mensajes_requeridos << un_mensaje
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

  def comprobar_conflicto_reducido(una_clase, simbolos_a_ignorar)
    symbol_methods_class = una_clase.instance_methods
    symbol_methods_trait = @hash_de_metodos.keys
    symbol_methods_conflict = symbol_methods_class.intersection(symbol_methods_trait) - simbolos_a_ignorar
    puts "simbolos a ignorar  #{simbolos_a_ignorar}"
    unless symbol_methods_conflict.empty?
      raise("Hay conflicto entre el trait y la clase , con los siguientes metodos #{symbol_methods_conflict}")
    end
  end
end

class TraitDisminuido
  def initialize(un_trait, un_ingnorar_simbolos)
    @trait_original = un_trait
    @array_ignorar_simbolos = [un_ingnorar_simbolos].flatten

  end

  def inyectarse_en(una_clase)
    @trait_original.inyectarse_de_forma_reducida(una_clase, @array_ignorar_simbolos)
  end

  def metodos_disponibles
    @trait_original.metodos_disponibles - @array_ignorar_symbols
  end
end

class TraitCompuesto
  def initialize(un_trait_a, un_trait_b, mensajes_requeridos)
    @trait_a = un_trait_a
    @trait_b = un_trait_b
    @mensajes_requeridos = mensajes_requeridos
  end

  def inyectarse_en(una_clase)
    @trait_a.inyectarse_en(una_clase)
    @trait_b.inyectarse_en(una_clase)
  end

  def restar(a_symbol)
    metodos = @trait_a.metodos_disponibles
    if metodos.include?(a_symbol)
      @trait_a = @trait_a.restar(a_symbol)
    end
    metodos = @trait_b.metodos_disponibles
    if metodos.include?(a_symbol)
      @trait_b = @trait_b.restar(a_symbol)
    end
    self
  end

  def sumar(un_trait)
    mensajes_requeridos = @mensajes_requeridos.union(un_trait.mensajes_requeridos)
    TraitCompuesto.new(self, un_trait, mensajes_requeridos)
  end

  def metodos_disponibles
    @trait_a.metodos_dispobibles + @trait_b.metodos_disponibles
  end

  def requiere(un_mensaje)
    @mensajes_requeridos << un_mensaje
  end

  def tiene_requeridos?
    @mensajes_requeridos.empty?
  end
end
