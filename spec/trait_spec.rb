require 'rspec'
require 'trait'

describe 'trait' do
  describe 'aplicacion de traits' do
    it 'Se aplica un trait a una clase y sus instancias responden a los metodos definidos por el trait' do
      # Preparacion
      un_trait = Trait.debe do
        def m1
          'hola trait'
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      # Ejercitacion
      un_trait.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.m1).to eq('hola trait')
    end

    it 'Se aplica un trait a una clase con un selector en conflicto y
        prevalece el comportamiento definido de la clase' do
      # Preparacion
      un_trait = Trait.debe do
        def m1
          'metodo m1'
        end
      end

      una_clase = Class.new do
        def m1
          'otro metodo m1'
        end
      end

      instancia = una_clase.new

      # Ejercitacion
      un_trait.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.m1).to eq('otro metodo m1')
    end

    it 'Se aplica un trait a una clase con un selector en conflicto definido en su jerarquia
        y prevalece el comportamiento de este ultimo' do
      # Preparacion
      un_trait = Trait.debe do
        def m1
          'metodo m1'
        end
      end

      super_clase = Class.new do
        def m1
          'otro metodo m1'
        end
      end

      una_subclase = Class.new(super_clase)
      instancia = una_subclase.new

      # Ejercitacion
      un_trait.aplicarse_en(una_subclase)

      # Verificacion
      expect(instancia.m1).to eq('otro metodo m1')
    end

    it 'No se puede aplicar traits con selectores en conflicto' do
      # Preparacion
      trait_1 =  Trait.debe do
        def m1
          "metodo m1"
        end
      end
      trait_2 = Trait.debe do
        def m1
          "otro metodo m1"
        end
      end

      una_clase = Class.new

      # Ejercitacion
      trait_compuesto = trait_1 + trait_2

      # Verificacion
      expect { trait_compuesto.aplicarse_en(una_clase) }.to raise_error("Conflicto entre traits")
    end

    it 'Se puede aplicar traits con selectores conflictivos, si son el mismo trait' do
      # Preparacion
      trait_1 =  Trait.debe do
        def m1
          "metodo m1"
        end
      end
      una_clase = Class.new
      instancia = una_clase.new

      # Ejercitacion
      trait_compuesto = trait_1 + trait_1
      trait_compuesto.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.m1).to eq("metodo m1")
    end

    it 'Se puede aplicar traits  conflictivos si son el mismo trait' do
      # Preparacion
      trait_1 = Trait.debe do

        def m1
          "metodo m1"
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      # Ejercitacion
      trait_compuesto = trait_1 + trait_1
      trait_compuesto.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.m1).to eq("metodo m1")
    end

    it 'Se puede aplicar traits con selectores conflictivos si los metodos son los mismos' do
      # Preparacion
      trait_1 = Trait.debe do
        def m1
          "metodo m1"
        end
      end
      trait_2 = trait_1.clone

      una_clase = Class.new
      instancia = una_clase.new

      # Ejercitacion
      trait_compuesto = trait_1 + trait_2
      trait_compuesto.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.m1).to eq("metodo m1")
    end
  end

  describe 'operaciones' do

    it 'Se resta un selector a un trait y las *instancias no responden al mismo' do
      # Preparacion
      un_trait = Trait.debe do
        def m1
          'metodo m1'
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      # Ejercitacion
      trait_disminuido = un_trait - (:m1)
      trait_disminuido.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.respond_to?(:m1)).to be(false)
    end

    it 'No se puede restar un selector que no contiene el trait' do
      # Preparacion
      un_trait = Trait.debe do
      end

      # Ejercitacion # Verificacion
      # mensaje de error que muestra (al menos que se haya cambiado):
      # No se puede restar un selector que no esta contenido en el trait
      expect{ un_trait - (:m1) }.to raise_error(TraitDisminuido.mensaje_de_error_en_resta)
    end

    it 'Los metodos asociados a un trait se consevan a pesar de la operacion que se le efectua' do
      un_trait = Trait.debe do
        def m1
          "m1"
        end
      end

      trait_disminuido = un_trait - :m1
      trait_alias = un_trait << {m1: :m2}
      trait_compuesto = un_trait + un_trait

      expect(trait_disminuido.metodos).to eq(un_trait.metodos)
      expect(trait_alias.metodos).to eq(un_trait.metodos)
      expect(trait_compuesto.metodos).to eq(un_trait.metodos)
    end


    it 'Se resta un selector a un trait que define varios metodos  y las instancias responden a los selectores definidos' do
      # Preparacion
      un_trait = Trait.debe do
        def m1
          'hola trait'
        end

        def m2
          'hola mundo'
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      # Ejercitacion
      trait_disminuido = un_trait - (:m2)
      trait_disminuido.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.m1).to eq('hola trait')
      expect(instancia.respond_to?(:m2)).to be(false)
    end

    it 'Se restan varios selectores al trait, la instancia solo responde a los metodos definidos' do
      # Preparacion
      un_trait = Trait.debe do
        def m1
          'hola trait'
        end

        def m2
          'hola mundo'
        end

        def m3
          'hola'
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      # Ejercitacion
      trait_disminuido = un_trait - :m1 - :m2
      trait_disminuido.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.m3).to eq('hola')
      expect(instancia.respond_to?(:m1)).to be(false)
      expect(instancia.respond_to?(:m2)).to be(false)
    end

    it 'Se restan un conjunto de mensajes a un trait y la instancia solo responde a los metodos definidos ' do
      # Preparacion
      un_trait = Trait.debe do
        def m1
          'hola trait'
        end

        def m2
          'hola mundo'
        end

        def m3
          'hola'
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      # Ejercitacion
      trait_disminuido = un_trait - [:m1, :m2]
      trait_disminuido.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.m3).to eq('hola')
      expect(instancia.respond_to?(:m1)).to be(false)
      expect(instancia.respond_to?(:m2)).to be(false)
    end

    it 'Se aplica un trait que es la composicion de varios traits, la instancia sabe responder con todos los metodos definidos por el trait' do
      # Preparacion
     trait_1 = Trait.debe do
       def m1
         'm1'
       end
     end

     trait_2 = Trait.debe do
       def m2
         'm2'
       end
     end

     trait_3 = Trait.debe do
       def m3
         'm3'
       end
     end
      una_clase = Class.new
      instancia = una_clase.new

      # Ejercitacion
     trait_compuesto = trait_1 + trait_2 + trait_3
     trait_compuesto.aplicarse_en(una_clase)

      # Verificacion
     expect(instancia.m1).to eq('m1')
     expect(instancia.m2).to eq('m2')
     expect(instancia.m3).to eq('m3')
    end

    it 'Se comprueba conflictos al aplicarse un trait complejo' do
      # Preparacion
      trait_1 = Trait.debe do
        def m1
          'm1'
        end
      end

      trait_2 = Trait.debe do
        def m1
          'm1'
        end

        def m2
          "m2"
        end
      end

      una_clase = Class.new

      # Ejercitacion
      trait_compuesto = ((trait_1 + trait_2) - :m2) << {m2: :m3}

      # Verificacion
      expect{trait_compuesto.aplicarse_en(una_clase)}.to raise_error("Conflicto entre traits")
    end

    it 'La combinacion de traits es asociativa, conmutable e idempotente' do
      # Preparacion
      trait_1 = Trait.debe do
        def m1
          'm1'
        end
      end

      trait_2 = Trait.debe do
        def m2
          'm2'
        end
      end

      trait_3 = Trait.debe do
        def m2
          'otro m2'
        end
      end

      # Ejercitacion # Verificacion
      # asociativa
      expect(trait_1 + (trait_2 + trait_3)).to eq((trait_1 + trait_2) + trait_3)

      # conmutativa
      expect(trait_1 + trait_2).to eq(trait_2 + trait_1)

      # idempotente
      expect(trait_1 + trait_1).to eq(trait_1)

      # conmutativa e idempotente
      expect((trait_1 + trait_2) + (trait_2 + trait_1)).to eq(trait_1 + trait_2)
      expect((trait_1 + trait_2) + (trait_2 + trait_1)).to eq(trait_2 + trait_1)

      # los trait pueden ser distintos, no era un truco!!!
      expect(trait_1 + trait_3).not_to eq(trait_1 + trait_2)
    end

    it 'Al restar un selector a un trait, ya no es igual al trait original' do
      # Preparacion
      un_trait = Trait.debe do
        def m1
          "metodo m1"
        end
      end

      # Ejercitacion
      trait_disminuido = un_trait - :m1

      # Verificacion
      expect(un_trait == trait_disminuido).to eq(false)
    end

    it 'Al generar un alias para un trait, el trait resultante ya no es igual al trait original' do
      # Preparacion
      un_trait = Trait.debe do
        def m1
          "metodo m1"
        end
      end

      # Ejercitacion
      trait_alias = un_trait << {m1: :m2}

      # Verificacion
      expect(un_trait == trait_alias).to eq(false)
    end
    it 'Un trait y otro objeto distinto a un trait no son iguales' do
      un_trait = Trait.debe do
      end
      objeto = Class.new.new

      # Ejercitacion # Verificacion
      expect(un_trait == objeto).to eq(false)
    end
  end

  describe 'requeridos' do

    it 'Al definirse un trait con requerimientos, el trait sabe que requerimientos son' do
      # Preparacion
      un_trait = Trait.debe do
        requiere :m2
        def m1
          self.m2
        end
      end

      # Ejercitacion # Verificacion
      expect(un_trait.selectores_requeridos).to eq(Set[:m2])
    end

    it 'Al aplicarse un trait con requerimientos no satisfechos la
        instancia no puede respoder al mensaje conflictivo' do
    # Preparacion
      un_trait = Trait.debe do
        requiere :m2
        def m1
          self.m2
        end
      end
      una_clase = Class.new
      instancia = una_clase.new

    # Ejercitacion
      un_trait.aplicarse_en(una_clase)

    # Verificacion
      expect { instancia.m1 }.to raise_error(NoMethodError)
    end

    it 'Al aplicarse un trait con requerimientos a una clase que satisface dichos requerimientos,
         la instancia responde ccrrectamente al metodo definido por el trait' do
      # Preparacion
      un_trait = Trait.debe do
        requiere :m2

        def m1
          m2
        end
      end
      una_clase = Class.new do
        def m2
          'm2'
        end
      end

      instancia = una_clase.new

      # Ejercitacion
      un_trait.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.m1).to eq('m2')
    end

    it 'Al combinarse un trait con requerimientos con otro trait que satisface el requerimiento,
         el trait resultante no conserva el requerimiento' do
      # Preparacion
      trait_1 = Trait.debe do
        requiere :m2

        def m1
          m2
        end
      end

      trait_2 = Trait.debe do
        def m2
          'm2'
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      # Ejercitacion
      trait_combinado = trait_1 + trait_2
      trait_combinado.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.m1).to eq('m2')
      expect(trait_combinado.selectores_requeridos.empty?).to be(true)
    end

    it 'Al combinarse un trait con requerimientos no satisfechos
         el trait resultante  conserva los mismo requerimientos' do
      # Preparacion
      trait_1 = Trait.debe do
        requiere :m2

        def m1
          self.m2
        end
      end
      trait_2 = Trait.debe do
        def m3
          'm3'
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      # Ejercitacion
      trait_combinado = trait_1 + trait_2
      trait_combinado.aplicarse_en(una_clase)

      # Verificacion
      expect { instancia.m1 }.to raise_error(NoMethodError)
      expect(trait_combinado.selectores_requeridos == Set[:m2]).to eq( true )
    end

    it 'Al combinarse varios trait con requerimientos no satisfechos,
         el trait resultante  conserva todos los requerimientos' do
      # Preparacion
      trait_1 = Trait.debe do
        requiere :m3

        def m1
          self.m3
        end
      end
      trait_2 = Trait.debe do
        requiere :m4

        def m2
          self.m4
        end
      end

      # Ejercitacion
      trait_combinado = trait_1 + trait_2

      # Verificacion
      expect(trait_combinado.selectores_requeridos == Set[:m3, :m4]).to eq( true )
    end

    it 'Al borrar un metodo con requerimientos, se pierden los requerimientos' do
      un_trait = Trait.debe do
        requiere :m2
        def m1
          m2
        end
      end

      trait_sin_m1 = un_trait - :m1

      expect(trait_sin_m1.selectores_requeridos).to eq(Set[])
    end
  end

  describe 'alias de mensajes' do

    it 'Se define un alias para un selector de un trait, al aplicarse el trait
        la instancia entiende el mensaje original y el alias' do
      # Preparacion
      un_trait = Trait.debe do
        def m1
          'metodo m1'
        end
      end

      una_clase = Class.new
      una_instancia = una_clase.new

      # Ejercitacion
      trait_con_alias = un_trait << { m1: :m2 }
      trait_con_alias.aplicarse_en una_clase

      # Verificacion
      expect(una_instancia.m1).to eq('metodo m1')
      expect(una_instancia.m2).to eq('metodo m1')
    end

    it 'Caso trait con varios metodos. Se define un alias para un selector de un trait y se conservan ambos asociados al mismo metodo' do
      # Preparacion
      un_trait = Trait.debe do
        def m1
          'metodo m1'
        end

        def m2
          'metodo m2'
        end
      end

      una_clase = Class.new
      una_instancia = una_clase.new

      # Ejercitacion
      trait_con_alias = un_trait << { m2: :mensaje_dos }
      trait_con_alias.aplicarse_en una_clase

      # Verificacion
      expect(una_instancia.m2).to eq('metodo m2')
      expect(una_instancia.mensaje_dos).to eq('metodo m2')
    end

    it 'Se define un alias para un trait, se resta el selector original
         la instancia solo entiende el alias' do
      # Preparacion
      trait_1 = Trait.debe do
        def m1
          "metodo m1"
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      # Ejercitacion
      trait_con_alias = (trait_1 << { m1: :m2 }) - :m1
      trait_con_alias.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.respond_to?(:m1)).to be(false)
      expect(instancia.m2).to eq("metodo m1")
    end

    it 'A traits con conflicto, se les define un alias y se resta el selector conflictivo a ambos,
        la instancia sabe respoder solo a los alias' do
      # Preparacion
      trait_1 = Trait.debe do
        def m1
          "metodo m1"
        end
      end
      trait_2 = Trait.debe do
        def m1
          "otro metodo m1"
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      # Ejercitacion
      trait_con_alias = ((trait_1 << { m1: :m2 }) - :m1) + ((trait_2 << { m1: :m3 }) - :m1)
      trait_con_alias.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.respond_to?(:m1)).to be(false)
      expect(instancia.m2).to eq("metodo m1")
      expect(instancia.m3).to eq("otro metodo m1")
    end

    it 'Al definir un alias a un trait con requerimientos, el alias no puede ser igual al de un requerimiento' do
      # Preparacion
      un_trait = Trait.debe do
        requiere :m2
        def m1
          m2
        end
      end

      # Ejercitacion # Verificacion
      expect{un_trait << { m1: :m2 }}.to raise_error("El alias no puede ser igual a un selector requerido")
    end

    it 'Un trait no puede tener como alias un selector en uso' do
      un_trait = Trait.debe do
        def m1
          "m1"
        end
      end

      expect { un_trait << {m1: :m1}}.to raise_error("El alias no puede ser igual a un selector disponible")

    end
  end

  describe 'Iterfaz de usuario' do

    it 'Se aplica un trait utilizando la interfaz de usuario' do
      # Preparacion # Ejercitacion
      trait Perro do
        def ladrar
          "guau guau"
        end
      end

      clase = Class.new do
        uses Perro
      end

      instancia = clase.new

      # Verificacion
      expect(instancia.ladrar).to eq("guau guau")
    end
  end
end

#*instancias = entiendase por instancia, a la instancia de la clase a la cual se aplico un trait
