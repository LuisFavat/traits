require 'rspec'
require 'trait_abstracto'
require 'trait'
require 'trait_disminuido'
require 'trait_compuesto'
require 'trait_alias'
require_relative '../lib/interfaz_de_usuario'

describe 'trait' do
  describe 'aplicacion de traits' do
    it 'Se aplica un trait a una clase y sus intancias responden a los selectores definidos por el trait' do
      un_trait = Trait.definir_comportamiento do
        def m1
          'm1 de trait'
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      un_trait.aplicarse_en(una_clase)

      expect(instancia.m1).to eq('m1 de trait')
    end

    it 'Se aplica un trait a una clase con un selector en comun y prevalece el comportamiento definido en la clase' do
      un_trait = Trait.definir_comportamiento do
        def m1
          'm1 de trait'
        end
      end

      una_clase = Class.new do
        def m1
          'm1 de clase'
        end
      end
      instancia = una_clase.new

      un_trait.aplicarse_en(una_clase)

      expect(instancia.m1).to eq('m1 de clase')
    end

    it 'Se aplica un trait a una clase con un selector definido en su jerarquia y prevalece el comportamiento de este ultimo' do
      un_trait = Trait.definir_comportamiento do
        def m1
          'm1 de trait'
        end
      end

      una_clase = Class.new do
        def m1
          'm1 de superclase'
        end
      end

      una_subclase = Class.new(una_clase) do
        def m2
          'm2 de subclase'
        end
      end

      instancia = una_subclase.new

      un_trait.aplicarse_en(una_subclase)

      expect(instancia.m1).to eq('m1 de superclase')
    end

    it 'Al combinar traits que tienen un mismo selector y querer aplicarlo se lanza una excepción' do
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

      # TODO: revisar esto que esta medio como el culo (el error tiene que ser otro y la logica ni hablar)
      expect{ trait_compuesto.aplicarse_en(una_clase) }.to raise_error("Conflicto entre traits")
    end
  end

  describe 'Algebra' do
    it 'Se resta un selector a un trait y las instancias de la clase donde se aplica no responden al mismo' do
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

    it 'Se resta un selector al resultado de restar otro a un trait y las instancias de la clase donde se aplica no
        responden a los mismos' do
      un_trait = Trait.definir_comportamiento do
        def m1
          'm1 de trait'
        end

        def m2
          'm2 de trait'
        end

        def m3
          'm3 de trait'
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      trait_disminuido = un_trait - :m1 - :m2
      trait_disminuido.aplicarse_en(una_clase)

      expect(instancia.m3).to eq('m3 de trait')
      expect(instancia.respond_to?(:m1)).to be(false)
      expect(instancia.respond_to?(:m2)).to be(false)
    end

    it 'Se restan un conjunto de selectores a un trait y las instancias de la clase donde se aplica no responden a los
        mismos' do
      un_trait = Trait.definir_comportamiento do
        def m1
          'm1 de trait'
        end

        def m2
          'm2 de trait'
        end

        def m3
          'm3 de trait'
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      trait_disminuido = un_trait - [:m1, :m2]
      trait_disminuido.aplicarse_en(una_clase)

      expect(instancia.m3).to eq('m3 de trait')
      expect(instancia.respond_to?(:m1)).to be(false)
      expect(instancia.respond_to?(:m2)).to be(false)
    end

    it 'Se componen varios traits, se aplican a una clase y sus instancias entienden los mensajes definidos por estos' do
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

      trait_compuesto = (trait_1 + trait_2) + (trait_2 + trait_1)

      expect(trait_1 + (trait_2 + trait_3)).to eq((trait_1 + trait_2) + trait_3)
      expect(trait_1 + trait_2).to eq(trait_2 + trait_1)
      expect(trait_compuesto).to eq(trait_1 + trait_2)
      expect(trait_compuesto).to eq(trait_2 + trait_1)
      expect(trait_1 + trait_3).not_to eq(trait_1 + trait_2)
      expect(trait_1 + trait_1).to eq(trait_1)
    end
  end

  describe 'requeridos' do
    it 'Al aplicarse un trait con requeridos no satisfechos y llamar al selector de una instancia de la clase que lo
        aplica falla' do
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

    it 'Al aplicarse un trait con requeridos a una clase que define el selector se invoca correctamente por la instancia' do
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

    it 'Al combinarse un trait con requeridos con otro que define el selector el trait resultante no conserva el requerimiento' do
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

    it 'Al combinarse un trait con requeridos y otro que no los satisface el resultante los conserva' do
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
      expect(trait_combinado.tiene_requeridos?).to be(true)
    end
  end

  describe 'alias de mensajes' do

    it 'Se define un alias para un selector de un trait y se conservan ambos asociados al mismo metodo' do

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

    it 'Se define un alias para un trait, se resta el selector original la instancia de la clase donde se aplica solo
        entiende el alias' do
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

    it 'A traits con conflicto, se les define un alias y se resta el selector conflictivo a ambos,
        la instancia sabe respoder solo a los alias' do
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

    it 'Se combinan dos traits con el mismo selector a los que se le dio un alias, al resultado se le quita el conflictivo
        resolviendose el conflicto' do
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

      trait_con_alias = ((trait_1 << { m1: :m2 }) + (trait_2 << { m1: :m3 })) - :m1
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
