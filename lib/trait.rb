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
  end

  def inyectarse_en(una_clase)
    @hash_de_metodos.each{|symbol, method| una_clase.define_method(symbol, method)}
  end

end
