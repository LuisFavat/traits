require 'rspec'
require 'trait'

describe 'trait' do
  describe 'aplicacion de traits' do
    it 'Se aplica un trait a una clase y sus intancias responden a los mensajes definidos por el trait' do
      #Preparacion
      un_trait = Trait.definir_comportamiento do
        def m1
          'hola trait'
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      un_trait.aplicarse_en(una_clase)

      expect(instancia.m1).to eq('hola trait')
    end

    it 'Se aplica un trait a una clase con un selector en comun y prevalece el comportamiento definido de la clase' do
      #Preparacion
      un_trait = Trait.definir_comportamiento do
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

      un_trait.aplicarse_en(una_clase)

      expect(instancia.m1).to eq('otro metodo m1')
    end

    it 'Se aplica un trait a una clase con un selector definido en su jerarquia y prevalece el comportamiento de este ultimo' do
      #Preparacion
      un_trait = Trait.definir_comportamiento do
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

      un_trait.aplicarse_en(una_subclase)

      expect(instancia.m1).to eq('otro metodo m1')
    end

    it 'No se puede aplicar traits con selectores en conflicto' do
      #Preparacion
      trait_1 =  Trait.definir_comportamiento do
        def m1
          "metodo m1"
        end
      end
      trait_2 = Trait.definir_comportamiento do
        def m1
          "otro metodo m1"
        end
      end

      una_clase = Class.new

      trait_compuesto = trait_1 + trait_2
      expect { trait_compuesto.aplicarse_en(una_clase) }.to raise_error("Conflicto entre traits")
    end

    it 'Se puede aplicar traits con selectores conflictivos, si son el mismo trait' do
      #Preparacion
      trait_1 =  Trait.definir_comportamiento do
        def m1
          "metodo m1"
        end
      end
      una_clase = Class.new
      instancia = una_clase.new

      trait_compuesto = trait_1 + trait_1
      trait_compuesto.aplicarse_en(una_clase)

      expect(instancia.m1).to eq("metodo m1")
    end

    it 'Se puede aplicar traits con selectores conflictivos si los metodos son los mismos' do
      # Preparacion
=begin
      modulo_con_metodo = Module.new {
        def self.m1
          "metodo m1"
        end
      }

      metodo_sin_vincular = modulo_con_metodo.method(:m1)
      puts "@here"
      puts metodo_sin_vincular
      comportamiento = proc {self.define_method(:m1, &metodo_sin_vincular)}


      trait_1 = Trait.definir_comportamiento(&comportamiento)
      trait_2 = Trait.definir_comportamiento(&comportamiento)
=end
      trait_1 = Trait.definir_comportamiento do
        def m1
          "metodo m1"
        end
      end
      trait_2 = Trait.definir_comportamiento do
      end

      una_clase = Class.new
      instancia = una_clase.new

      trait_compuesto = trait_1 + trait_2
      trait_compuesto.aplicarse_en(una_clase)

      expect(instancia.m1).to eq("metodo m1")
    end

    it 'idem ant pero de otra forma' do
      # Preparacion

      trait_1 = Trait.definir_comportamiento do
        def m1
          "metodo m1"
        end
      end
      trait_2 = trait_1.clone

      una_clase = Class.new
      instancia = una_clase.new

      trait_compuesto = trait_1 + trait_2
      trait_compuesto.aplicarse_en(una_clase)

      expect(trait_1.__id__).not_to eq(trait_2.__id__)
      expect(instancia.m1).to eq("metodo m1")
    end
  end


  describe 'Algebra' do
    it 'Se resta un selector a un trait y las instancias no responden al mismo' do
      # Preparacion
      un_trait = Trait.definir_comportamiento do
        def m1
          'metodo m1'
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      trait_disminuido = un_trait - (:m1)
      trait_disminuido.aplicarse_en(una_clase)

      expect(instancia.respond_to?(:m1)).to be(false)
    end

    it 'No se puede restar un selector que no contiene el trait' do
      # Preparacion
      un_trait = Trait.definir_comportamiento do
      end

      # mensaje de error que muestra (al menos que se haya cambiado):
      # No se puede restar un selector que no esta contenido en el trait
      expect{ un_trait - (:m1) }.to raise_error(TraitDisminuido.mensaje_de_error_en_resta)
    end

    it 'Se resta un selector a un trait que define varios metodos  y las instancias responden a los selectores definidos' do
      # Preparacion
      un_trait = Trait.definir_comportamiento do
        def m1
          'hola trait'
        end

        def m2
          'hola mundo'
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      trait_disminuido = un_trait - (:m2)
      trait_disminuido.aplicarse_en(una_clase)

      expect(instancia.m1).to eq('hola trait')
      expect(instancia.respond_to?(:m2)).to be(false)
    end

    it 'Se restan varios selectores al trait, la instancia solo responde a los metodos definidos' do
      # Preparacion
      un_trait = Trait.definir_comportamiento do
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

      trait_disminuido = un_trait - :m1 - :m2
      trait_disminuido.aplicarse_en(una_clase)

      expect(instancia.m3).to eq('hola')
      expect(instancia.respond_to?(:m1)).to be(false)
      expect(instancia.respond_to?(:m2)).to be(false)
    end

    it 'Se restan un conjunto de mensajes a un trait y la instancia solo responde a los metodos definidos ' do
      # Preparacion
      un_trait = Trait.definir_comportamiento do
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

      trait_disminuido = un_trait - [:m1, :m2]
      trait_disminuido.aplicarse_en(una_clase)

      trait_d = TraitDisminuido.new(un_trait, :m1)

      expect(instancia.m3).to eq('hola')
      expect(instancia.respond_to?(:m1)).to be(false)
      expect(instancia.respond_to?(:m2)).to be(false)
    end

    it 'Se aplica un trait que es la composicion de varios traits, la instancia sabe responder con todos los metodos definidos por el trait' do
      # Preparacion
     trait_1 = Trait.definir_comportamiento do
       def m1
         'm1'
       end
     end

     trait_2 = Trait.definir_comportamiento do
       def m2
         'm2'
       end
     end

     trait_3 = Trait.definir_comportamiento do
       def m3
         'm3'
       end
     end

     trait_compuesto = trait_1 + trait_2 + trait_3

     una_clase = Class.new
     instancia = una_clase.new

     trait_compuesto.aplicarse_en(una_clase)

     expect(instancia.m1).to eq('m1')
     expect(instancia.m2).to eq('m2')
     expect(instancia.m3).to eq('m3')
   end

    it 'La combinacion de traits es asociativa, conmutable e idempotente' do
      trait_1 = Trait.definir_comportamiento do
        def m1
          'm1'
        end
      end

      trait_2 = Trait.definir_comportamiento do
        def m2
          'm2'
        end
      end

      trait_3 = Trait.definir_comportamiento do
        def m2
          'otro m2'
        end
      end

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
  end

  describe 'requeridos' do
    it 'Al aplicarse un trait con requerimientos no satisfechos la instancia no puede respoder al mensaje conflictivo' do
      un_trait = Trait.definir_comportamiento do
        requiere :m2
        def m1
          self.m2
        end
      end
      una_clase = Class.new
      instancia = una_clase.new

      un_trait.aplicarse_en(una_clase)

      expect { instancia.m1 }.to raise_error(NoMethodError)
    end

    it 'Al aplicarse un trait con requerimientos a una clase que satisface dichos requerimientos, la instancia responde ccrrectamente al metodo definido por el trait' do
      un_trait = Trait.definir_comportamiento do
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

      un_trait.aplicarse_en(una_clase)

      expect(instancia.m1).to eq('m2')
    end

    it 'Al combinarse un trait con requerimientos con otro trait que satisface el requerimiento,
         el trait resultante no conserva el requerimiento' do

      trait_1 = Trait.definir_comportamiento do
        requiere :m2

        def m1
          m2
        end
      end

      trait_2 = Trait.definir_comportamiento do
        def m2
          'm2'
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      trait_combinado = trait_1 + trait_2
      trait_combinado.aplicarse_en(una_clase)

      expect(instancia.m1).to eq('m2')
      expect(trait_combinado.tiene_requeridos?).to be(false)
    end

    it 'Al combinarse un trait con requerimientos no satisfechos, el trait resultante  conserva los mismo requerimientos' do
      trait_1 = Trait.definir_comportamiento do
        requiere :m2

        def m1
          self.m2
        end
      end
      trait_2 = Trait.definir_comportamiento do
        def m3
          'm3'
        end
      end

      una_clase = Class.new
      instancia = una_clase.new


      trait_combinado = trait_1 + trait_2
      trait_combinado.aplicarse_en(una_clase)

      expect { instancia.m1 }.to raise_error(NoMethodError)
      expect(trait_combinado.selectores_requeridos == Set[:m2]).to eq( true )
    end

    it 'Al combinarse un trait con requerimientos no satisfechos, el trait resultante  conserva los mismo requerimientos fgd' do
      trait_1 = Trait.definir_comportamiento do
        requiere :m3

        def m1
          self.m3
        end
      end
      trait_2 = Trait.definir_comportamiento do
        requiere :m4

        def m2
          self.m4
        end
      end

      una_clase = Class.new
      instancia = una_clase.new


      trait_combinado = trait_1 + trait_2

      expect(trait_combinado.selectores_requeridos == Set[:m3, :m4]).to eq( true )
    end
  end

  describe 'alias de mensajes' do


    it 'Se define un alias para un mensaje de un trait, al aplicarse la instancia entiende el mensaje original y el alias' do

      un_trait = Trait.definir_comportamiento do
        def m1
          'metodo m1'
        end
      end

      una_clase = Class.new
      una_instancia = una_clase.new

      trait_con_alias = un_trait << { m1: :m2 }
      trait_con_alias.aplicarse_en una_clase

      expect(una_instancia.m1).to eq('metodo m1')
      expect(una_instancia.m2).to eq('metodo m1')
    end

    it 'Se define un alias para un mensaje de un trait y se conservan ambos asociados al mismo metodo' do

      un_trait = Trait.definir_comportamiento do
        def mensaje
          'este es mensaje'
        end

        def otro_mensaje
          'este es otro mensaje'
        end
      end

      una_clase = Class.new
      una_instancia = una_clase.new

      trait_con_alias = un_trait << { otro_mensaje: :mensaje_dos }
      trait_con_alias.aplicarse_en una_clase

      expect(una_instancia.otro_mensaje).to eq('este es otro mensaje')
      expect(una_instancia.mensaje_dos).to eq('este es otro mensaje')
    end

    it 'jkdsljflsjd dasfsdf' do
      trait_1 = Trait.definir_comportamiento do
        def m1
          "metodo m1"
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      trait_con_alias = (trait_1 << { m1: :m2 }) - :m1

      trait_con_alias.aplicarse_en(una_clase)

      expect(instancia.respond_to?(:m1)).to be(false)
      expect(instancia.m2).to eq("metodo m1")
    end

    it 'should dasfsdf' do
      trait_1 = Trait.definir_comportamiento do
        def m1
          "metodo m1"
        end
      end
      trait_2 = Trait.definir_comportamiento do
        def m1
          "otro metodo m1"
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      trait_con_alias = ((trait_1 << { m1: :m2 }) - :m1) + ((trait_2 << { m1: :m3 }) - :m1)

      trait_con_alias.aplicarse_en(una_clase)

      expect(instancia.respond_to?(:m1)).to be(false)
      expect(instancia.m2).to eq("metodo m1")
      expect(instancia.m3).to eq("otro metodo m1")
    end
  end

  describe 'Iterfaz de usuario' do

    it 'Se aplica un trait utilizando la interfaz de usuario' do
      trait Perro do
        def ladrar
          "guau guau"
        end
      end

      clase = Class.new do
        uses Perro
      end

      instancia = clase.new

      expect(instancia.ladrar).to eq("guau guau")
    end
  end
end
