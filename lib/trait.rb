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
    #@}
    # trait_ancestors = nil
    @hash_de_metodos = un_hash_de_metodos
    @ignorar_symbols = un_ignorar_symbols
  end

  def inyectarse_en(una_clase)
    comprobar_conflicto_en(una_clase)
      @hash_de_metodos.each{|symbol, method|
        unless @ignorar_symbols.include?(symbol)
          una_clase.define_method(symbol, method)
        end
        }
  end

  def restar(*un_symbol_method)
    #ojito que estoy pasando el hash y no una copia
    Trait.new(@hash_de_metodos, un_symbol_method)
  end

  private
  def comprobar_conflicto_en(una_clase)
    symbol_methods_class = una_clase.instance_methods
    symbol_methods_trait = @hash_de_metodos.keys
    symbol_methods_conflict = symbol_methods_class.intersection(symbol_methods_trait) - @ignorar_symbols
    unless symbol_methods_conflict.empty?
      raise("Hay conflicto entre el trait y la clase , con los siguientes metodos #{symbol_methods_conflict}")
    end
  end

end
