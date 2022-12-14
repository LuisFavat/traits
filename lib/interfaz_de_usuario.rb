def trait(nombre, &bloque_de_definiciones)
  Object.const_set(nombre, TraitSimple.crear_desde_bloque(&bloque_de_definiciones))
end

def uses(trait)
  trait.aplicarse_en(self)
end

def Object.const_missing(name)
  name
end
