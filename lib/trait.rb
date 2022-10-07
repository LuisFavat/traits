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
  def initialize(un_hash_de_metodos, un_ignorar_symbols = [])
    @hash_de_metodos = un_hash_de_metodos
    @array_ignorar_symbols = un_ignorar_symbols
  end

  def inyectarse_en(una_clase)
    comprobar_conflicto_en(una_clase)
      @hash_de_metodos.each{|symbol, method|
        unless @array_ignorar_symbols.include?(symbol)
          una_clase.define_method(symbol, method)
        end
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
    @hash_de_metodos.keys - @array_ignorar_symbols
  end

  private
  def comprobar_conflicto_en(una_clase)
    symbol_methods_class = una_clase.instance_methods
    symbol_methods_trait = @hash_de_metodos.keys
    symbol_methods_conflict = symbol_methods_class.intersection(symbol_methods_trait) - @array_ignorar_symbols
    unless symbol_methods_conflict.empty?
      raise("Hay conflicto entre el trait y la clase , con los siguientes metodos #{symbol_methods_conflict}")
    end
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
    @array_ignorar_simbolos = []
    @array_ignorar_simbolos << un_ingnorar_simbolos
  end

  def inyectarse_en(una_clase)
    @trait_original.inyectarse_de_forma_reducida(una_clase, @array_ignorar_simbolos)
  end
end

class TraitCompuesto
  def initialize(un_trait_a, un_trait_b)
    @trait_a = un_trait_a
    @trait_b = un_trait_b
  end

  def inyectarse_en(una_clase)
    @trait_a.inyectarse_en(una_clase)
    @trait_b.inyectarse_en(una_clase)
  end

  def restar(a_symbol)

    @trait_a = @trait_a.restar(a_symbol)
    @trait_b = @trait_b.restar(a_symbol)
    self
  end

  def sumar(un_trait)
    TraitCompuesto.new(self, un_trait)
  end
end
