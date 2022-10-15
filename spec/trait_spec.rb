require 'rspec'
require 'trait'
require 'trait_simple'
require 'trait_disminuido'
require 'trait_compuesto'
require 'trait_alias'
require_relative '../lib/interfaz_de_usuario'

describe 'trait' do
  describe 'Aplicacion de traits' do
    it 'Se aplica un trait a una clase y sus intancias responden a los selectores definidos por el trait' do
      un_trait = TraitSimple.definir_comportamiento do
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
      un_trait = TraitSimple.definir_comportamiento do
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
      un_trait = TraitSimple.definir_comportamiento do
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

    it 'No se puede aplicar un trait del resultado de combinar dos traits con un selector en comun' do
      trait_1 =  TraitSimple.definir_comportamiento do
        def m1
          "metodo m1"
        end
      end

      trait_2 = TraitSimple.definir_comportamiento do
        def m1
          "otro metodo m1"
        end
      end

      una_clase = Class.new

      trait_compuesto = trait_1 + trait_2

      expect {trait_compuesto.aplicarse_en(una_clase)}.to raise_error TraitConConflictoError
    end
  end

  describe 'Conflictos' do
    it 'Combinar dos traits que tienen un selector en comun genera un conflicto' do
      trait_1 =  TraitSimple.definir_comportamiento do
        def m1
          "metodo m1"
        end
      end

      trait_2 = TraitSimple.definir_comportamiento do
        def m1
          "otro metodo m1"
        end
      end

      trait_compuesto = trait_1 + trait_2

      expect(trait_compuesto.tiene_conflicto?).to be(true)
    end

    it 'Al combinar un trait conflictivo con otro el resultante tiene conflicto' do
      trait_1 =  TraitSimple.definir_comportamiento do
        def m1
          "metodo m1"
        end
      end

      trait_2 = TraitSimple.definir_comportamiento do
        def m1
          "otro metodo m1"
        end
      end

      trait_3 = TraitSimple.definir_comportamiento do
        def m2
          "metodo m2"
        end
      end

      trait_compuesto = (trait_1 + trait_2) + trait_3
      otro_trait_compuesto = trait_3 + (trait_1 + trait_2)

      expect(trait_compuesto.tiene_conflicto?).to be(true)
      expect(otro_trait_compuesto.tiene_conflicto?).to be(true)
    end

    it 'A un trait conflictivo se le resta el selector del conflicto y se resuelve' do
      trait_1 =  TraitSimple.definir_comportamiento do
        def m1
          "metodo m1"
        end
      end

      trait_2 = TraitSimple.definir_comportamiento do
        def m1
          "otro metodo m1"
        end
      end

      trait_compuesto = (trait_1 + trait_2) - :m1

      expect(trait_compuesto.tiene_conflicto?).to be(false)
    end

    it 'Dar un alias a un selector conflictivo no resuelve el conflicto' do
      trait_1 =  TraitSimple.definir_comportamiento do
        def m1
          "metodo m1"
        end
      end

      trait_2 = TraitSimple.definir_comportamiento do
        def m1
          "otro metodo m1"
        end
      end

      trait_alias = (trait_1 + trait_2) << { m1: :m2 }

      expect(trait_alias.tiene_conflicto?).to be(true)
    end

  end

  describe 'Algebra' do
    it 'Los traits saben diferenciarse de aquello que no son traits' do
      un_trait = TraitSimple.definir_comportamiento do
        def m1
          "m1"
        end
      end

      expect(un_trait).not_to eq("algo que no es un trait")
      expect(un_trait).not_to eq(2)
      expect(un_trait).not_to eq(nil)
    end

    it 'Dos traits con los mismos selectores no son iguales si estan asociados a metodos distintos' do
      un_trait = TraitSimple.definir_comportamiento do
        def m1
          "m1"
        end

        def m2
          "m2"
        end
      end

      otro_trait = TraitSimple.definir_comportamiento do
        def m2
          "m2"
        end
      end

      trait_operado = (un_trait - :m2) + otro_trait

      expect(un_trait.selectores_disponibles).to eq(trait_operado.selectores_disponibles)
      expect(un_trait.selectores_requeridos).to eq(trait_operado.selectores_requeridos)
      expect(un_trait.metodos).not_to eq(trait_operado.metodos)
      expect(un_trait).not_to eq(trait_operado)
    end

    #TODO: tener en cuenta este caso porque demuestra la potencia del modelo alcanzado
=begin
    it 'Dos traits con los mismos metodos y selectores pero distintos requeridos son distintos' do
      un_trait = TraitSimple.definir_comportamiento do
        requiere :m3
        def m1
          self.m3
        end

        def m2
          "m2"
        end
      end

      otro_trait = TraitSimple.definir_comportamiento do
        def m3
          "m3"
        end
      end

      trait_operado = (un_trait + otro_trait) - :m3

      expect(un_trait.selectores_disponibles).to eq(trait_operado.selectores_disponibles)
      expect(un_trait.metodos).to eq(trait_operado.metodos)
      expect(un_trait.selectores_requeridos).not_to eq(trait_operado.selectores_requeridos)
      expect(un_trait).not_to eq(trait_operado)
    end
=end

    it 'No se puede restar un selector a un trait si no lo define' do
      un_trait = TraitSimple.definir_comportamiento do
        def m1
          'hola trait'
        end
      end

      expect{ un_trait - :m2 }.to raise_error NoDefineSelector
    end

    it 'Se resta un selector a un trait y las instancias de la clase donde se aplica no responden al mismo' do
      un_trait = TraitSimple.definir_comportamiento do
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
      un_trait = TraitSimple.definir_comportamiento do
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
      un_trait = TraitSimple.definir_comportamiento do
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
     trait_1 = TraitSimple.definir_comportamiento do
       def m1
         'm1'
       end
     end

     trait_2 = TraitSimple.definir_comportamiento do
       def m2
         'm2'
       end
     end

     trait_3 = TraitSimple.definir_comportamiento do
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

    it 'La combinacion de traits es asociativa, conmutativa e idempotente' do
      trait_1 = TraitSimple.definir_comportamiento do
        def m1
          'm1'
        end
      end

      trait_2 = TraitSimple.definir_comportamiento do
        def m2
          'm2'
        end
      end

      trait_3 = TraitSimple.definir_comportamiento do
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

  describe 'Requeridos' do
    it 'Un trait puede no tener metodos requeridos' do
      un_trait = TraitSimple.definir_comportamiento do
        def m1
          "metodo m1"
        end
      end

      expect(un_trait.tiene_requeridos?).to be(false)
    end

    it 'Al aplicarse un trait con requeridos no satisfechos y llamar al selector de una instancia de la clase que lo
        aplica falla' do
      un_trait = TraitSimple.definir_comportamiento do
        requiere :m2
        def m1
          self.m2
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      un_trait.aplicarse_en(una_clase)

      expect(un_trait.tiene_requeridos?).to be(true)
      expect { instancia.m1 }.to raise_error(NoMethodError)
    end

    it 'Eliminar un selector no genera cambios respecto a los requeridos de un trait' do
      un_trait = TraitSimple.definir_comportamiento do
        requiere :m2
        def m1
          self.m2
        end

        def m3
          "m3"
        end
      end

      trait_operado = un_trait - :m3

      una_clase = Class.new
      instancia = una_clase.new

      trait_operado.aplicarse_en(una_clase)

      expect(trait_operado.tiene_requeridos?).to be(true)
      expect { instancia.m1 }.to raise_error(NoMethodError)
    end

    it 'Combinar dos traits con requeridos hace que el resultante conserve los requeridos de ambos' do
      un_trait = TraitSimple.definir_comportamiento do
        requiere :m2
        def m1
          self.m2
        end

        def m3
          "m3"
        end
      end

      otro_trait = TraitSimple.definir_comportamiento do
        requiere :m4
        def m5
          self.m4
        end
      end

      trait_combinado = (un_trait -:m3) + otro_trait

      expect(trait_combinado.selectores_requeridos).to eq(Set.new([:m2, :m4]))
    end

    it 'Al combinarse un trait con requeridos con otro que define el selector el trait resultante no conserva el requerimiento' do
      trait_1 = TraitSimple.definir_comportamiento do
        requiere :m2

        def m1
          m2
        end
      end

      trait_2 = TraitSimple.definir_comportamiento do
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
      trait_1 = TraitSimple.definir_comportamiento do
        requiere :m2
        def m1
          self.m2
        end
      end

      trait_2 = TraitSimple.definir_comportamiento do
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

    it 'Definir un alias con un selector requerido satisface el requerimiento' do
      trait_1 = TraitSimple.definir_comportamiento do
        requiere :m2
        def m1
          self.m2
        end

        def m3
          "m3"
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      trait_alias = trait_1 << {m3: :m2}
      trait_alias.aplicarse_en(una_clase)

      expect(trait_alias.tiene_requeridos?).to be(false)
      expect(instancia.m2).to eq("m3")
    end

  end

  describe 'Alias de mensajes' do

    it 'Dar un alias a un selector de un trait cambia los selectores disponibles pero no los metodos definidos' do
      un_trait = TraitSimple.definir_comportamiento do
        def mensaje
          'este es mensaje'
        end
      end

      trait_alias = un_trait << {mensaje: :otro_mensaje}

      expect(un_trait.metodos).to eq(trait_alias.metodos)
      expect(un_trait.selectores_disponibles).not_to eq(trait_alias.selectores_disponibles)
    end

    it 'Se define un alias para un selector de un trait y se conservan ambos asociados al mismo metodo' do
      un_trait = TraitSimple.definir_comportamiento do
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
      trait_1 = TraitSimple.definir_comportamiento do
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
      trait_1 = TraitSimple.definir_comportamiento do
        def m1
          "metodo m1"
        end
      end

      trait_2 = TraitSimple.definir_comportamiento do
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
      trait_1 = TraitSimple.definir_comportamiento do
        def m1
          "metodo m1"
        end
      end

      trait_2 = TraitSimple.definir_comportamiento do
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
