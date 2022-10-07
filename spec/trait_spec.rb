
require 'rspec'
require 'trait'

describe 'trait' do
  describe 'algo' do
    it 'Se aplica un trait a una clase y sus intancias responden a los mensajes definidos por el trait' do
      un_trait = Trait.definir_metodos do
        def m1
          "hola trait"
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      un_trait.inyectarse_en(una_clase)

      expect(instancia.m1).to eq("hola trait")
    end

    it 'Se aplica un trait a una clase con un mensaje en comun y prevalece el comportamiento definido de la clase' do
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

      un_trait.inyectarse_en(una_clase)

      expect(instancia.m1).to eq("hola, soy una_clase")
    end
  end

  describe 'Algebra' do
    it 'Se resta un mensaje a un trait y las instancias no responden al mismo' do
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

      trait_disminuido = un_trait.restar(:m2)
      trait_disminuido.inyectarse_en(una_clase)

      expect(instancia.m1).to eq("hola trait")
      expect(instancia.respond_to?(:m2)).to be(false)
    end

    it 'Se componen varios traits, se aplican a una clase y sus instancias entienden los mensajes definidos por ambos' do
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

      trait_compuesto = (trait_1.sumar(trait_2)).sumar(trait_3)

      una_clase = Class.new
      instancia = una_clase.new

      trait_compuesto.inyectarse_en(una_clase)

      expect(instancia.m1).to eq("m1")
      expect(instancia.m2).to eq("m2")
      expect(instancia.m3).to eq("m3")
    end

    it 'Se componen varios traits, se aplican a una clase y sus instancias entienden los mensajes definidos por ambos' do
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

      trait_compuesto = (trait_1.sumar(trait_2)).sumar(trait_3)

      una_clase = Class.new
      instancia = una_clase.new

      trait_compuesto.inyectarse_en(una_clase)

      expect(instancia.m1).to eq("m1")
      expect(instancia.m2).to eq("m2")
      expect(instancia.m3).to eq("m3")
    end
  end
  describe 'requeridos' do
    it 'klsdjfgklj' do
      un_trait = Trait.definir_metodos do
        def m1
          self.m2
        end
      end
      una_clase = Class.new
      instancia = una_clase.new

      un_trait.requiere(:m2)
      un_trait.inyectarse_en(una_clase)


      expect{instancia.m1}.to raise_error( NoMethodError )
    end

    it 'klsdjfgklgldñfkgñldkj' do
      un_trait = Trait.definir_metodos do
        def m1
          self.m2
        end
      end
      una_clase = Class.new do
        def m2
          "m2"
        end
      end

      instancia = una_clase.new

      un_trait.requiere(:m2)
      un_trait.inyectarse_en(una_clase)

      expect(instancia.m1).to eq("m2")
    end

    it 'klsdjfgklgldñfkgñldkjksjflksjdf' do
      un_trait_1 = Trait.definir_metodos do
        def m1
          self.m2
        end
      end
      un_trait_2 = Trait.definir_metodos do
        def m2
          "m2"
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      un_trait_1.requiere(:m2)
      trait_combinado =  un_trait_1.sumar(un_trait_2)
      trait_combinado.inyectarse_en(una_clase)

      expect(instancia.m1).to eq("m2")
      expect(trait_combinado.tiene_requeridos?).to be(false)
    end

    it 'klsdjfgklgldñfkgñldkjk587467sjflksjdf' do
      un_trait_1 = Trait.definir_metodos do
        def m1
          self.m2
        end
      end
      un_trait_2 = Trait.definir_metodos do
        def m3
          "m3"
        end
      end

      una_clase = Class.new
      instancia = una_clase.new

      un_trait_1.requiere(:m2)
      trait_combinado =  un_trait_1.sumar(un_trait_2)
      trait_combinado.inyectarse_en(una_clase)

      expect{instancia.m1}.to raise_error(NoMethodError)
      expect(trait_combinado.tiene_requeridos?).to be(true)
    end
  end

  it 'klsdjfgklgldñfkgñldkfdgdk587467sjflksjdf' do


  end


end

