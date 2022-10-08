
require 'rspec'
require 'trait'

describe 'trait' do
  describe 'algo' do
    it 'Se aplica un trait a una clase y sus intancias responden a los mensajes definidos por el trait' do
      # Preparacion
      un_trait = Trait.definir_metodos do
        def m1
          "hola trait"
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      # Ejercitacion
      un_trait.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.m1).to eq("hola trait")
    end

    it 'Se aplica un trait a una clase con un mensaje en comun y prevalece el comportamiento definido de la clase' do
      # Preparacion
      un_trait = Trait.definir_metodos do
        def m1
          "hola trait"
        end
      end

      una_clase = Class.new do
        def m1
          "hola, soy una_clase"
        end
      end
      instancia = una_clase.new

      # Ejercitacion
      un_trait.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.m1).to eq("hola, soy una_clase")
    end
  end

  describe 'Algebra' do
    it 'Se resta un mensaje a un trait y las instancias no responden al mismo' do
      # Preparacion
      un_trait = Trait.definir_metodos do
        def m1
          "hola trait"
        end

        def m2
          "hola mundo"
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      # Ejercitacion
      trait_disminuido = un_trait.restar(:m2)
      trait_disminuido.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.m1).to eq("hola trait")
      expect(instancia.respond_to?(:m2)).to be(false)
    end

    it 'Se componen varios traits, se aplican a una clase y sus instancias entienden los mensajes definidos por ambos' do
      # Preparacion
      trait_1 = Trait.definir_metodos do
        def m1
          "m1"
        end
      end
      trait_2 = Trait.definir_metodos do
        def m2
          "m2"
        end
      end
      trait_3 = Trait.definir_metodos do
        def m3
          "m3"
        end
      end

      # Ejercitacion
      trait_compuesto = (trait_1.sumar(trait_2)).sumar(trait_3)

      una_clase = Class.new
      instancia = una_clase.new

      trait_compuesto.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.m1).to eq("m1")
      expect(instancia.m2).to eq("m2")
      expect(instancia.m3).to eq("m3")
    end

    it 'Se componen varios traits, se aplican a una clase y sus instancias entienden los mensajes definidos por ambos' do
      # Preparacion
      trait_1 = Trait.definir_metodos do
        def m1
          "m1"
        end
      end
      trait_2 = Trait.definir_metodos do
        def m2
          "m2"
        end
      end
      trait_3 = Trait.definir_metodos do
        def m3
          "m3"
        end
      end

      # Ejercitacion
      trait_compuesto = (trait_1.sumar(trait_2)).sumar(trait_3)

      una_clase = Class.new
      instancia = una_clase.new

      trait_compuesto.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.m1).to eq("m1")
      expect(instancia.m2).to eq("m2")
      expect(instancia.m3).to eq("m3")
    end
  end
  describe 'mensajes requeridos' do
    it 'Al aplicar un trait con requerimientos a una clase que no satisface los requerimientos se levanta una excepcion' do
      #Preparacion
      un_trait = Trait.definir_metodos do
        requiere(:m2)
        def m1
          self.m2
        end
      end
      una_clase = Class.new

      # Ejercitacion # Verificacion
      expect{un_trait.aplicarse_en(una_clase)}.to raise_error( "Faltan los siguientes metoddos requeridos: [:m2]" )
    end

    it 'Al aplicar un trait con requerimientos a una clase que satisface los requerimientos, se aplica correctamente el trait' do
      #Preparacion
      un_trait = Trait.definir_metodos do
        requiere(:m2)
        def m1
          self.m2
        end
      end
      una_clase = Class.new do
        def m2
          "m2"
        end
      end

      # Ejercitacion
      instancia = una_clase.new
      un_trait.aplicarse_en(una_clase)

      # Verificacion
      expect(instancia.m1).to eq("m2")
    end

    it 'Al combinar traits con requerimientos y traits que satisfacen dichos requerimientos, el nuevo trait no tiene requerimientos' do
      # Preparacion
      un_trait_1 = Trait.definir_metodos do
        requiere(:m2)
        def m1
          self.m2
        end
      end
      un_trait_2 = Trait.definir_metodos do
        def m2
          "m2"
        end
      end
      # Ejercitacion
      trait_combinado = un_trait_1.sumar(un_trait_2)

      # Verificacion # Ejercitacion
      expect(trait_combinado.tiene_requeridos?).to be(false)
    end

    it 'Al combinar traits con requerimientos con otros que no satisfacen dichos requerimientos, el trait resultante tiene requerimietos' do
      # Preparacion
      un_trait_1 = Trait.definir_metodos do
        requiere(:m2)
        def m1
          self.m2
        end
      end
      un_trait_2 = Trait.definir_metodos do
        def m3
          "m3"
        end
      end

      # Verificacion
      trait_combinado = un_trait_1.sumar(un_trait_2)

      # Verificacion
      expect(trait_combinado.tiene_requeridos?).to be(true)
    end

    it 'should ' do


    end
  end
end

