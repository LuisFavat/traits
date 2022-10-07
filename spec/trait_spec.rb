
require 'rspec'
require 'trait'

describe 'trait' do
  it 'Se crea un trait en una clase sin conflictos, se le puede mandar los mensajes definidos por el trair a la instancia' do
    trait = Trait.definir_metodos do
      def m1
        "hola trait"
      end
    end

    una_clase = Class.new
    instancia = una_clase.new

    trait.inyectarse_en(una_clase)

    expect(instancia.m1).to eq("hola trait")
  end

  it 'Se inyecta un trait en una clase con conflicto, se lanza una excepcion' do
    trait = Trait.definir_metodos do
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

    expect{trait.inyectarse_en(una_clase)}.to raise_error("Hay conflicto entre el trait y la clase , con los siguientes metodos [:m1]")
  end

  it 'Se tiene un trait y una clase con conflictos, se resuelve el conflicto sacando los metodos conflictivos' do
    trait_con_conflicto = Trait.definir_metodos do
      def m1
        "hola trait"
      end
    end

    una_clase = Class.new do
      def m1
        "hola, soy una_clase"
      end

      def m2
        "hola mundo"
      end
    end
    instancia = una_clase.new

    trait_sin_conflicto = trait_con_conflicto.restar(:m1)
    trait_sin_conflicto.inyectarse_en(una_clase)

    expect(instancia.m1).to eq("hola, soy una_clase")
    expect(instancia.m2).to eq("hola mundo")
  end

  it 'Se inyecta la composicion de dos traits a una clase, la instancia entiende los mensajes definidos por ambos traits' do
    trait_1 = Trait.definir_metodos do
      def m1
        "hola mundo"
      end
    end
    trait_2 = Trait.definir_metodos do
      def m2
        "chau mundo"
      end
    end

    trait_compuesto = trait_1.sumar(trait_2)

    una_clase = Class.new
    instancia = una_clase.new

    trait_compuesto.inyectarse_en(una_clase)

    expect(instancia.m1).to eq("hola mundo")
    expect(instancia.m2).to eq("chau mundo")
  end

  it 'Se inyecta la composicion de dos traits a una clase con conflicto, se lanza una excepcion' do
    trait_1 = Trait.definir_metodos do
      def m1
        "hola mundo"
      end
    end
    trait_2 = Trait.definir_metodos do
      def m2
        "chau mundo"
      end
    end

    trait_compuesto = trait_1.sumar(trait_2)

    una_clase = Class.new do
      def m1
        "soy una clase"
      end
    end

    expect{trait_compuesto.inyectarse_en(una_clase)}.to raise_error("Hay conflicto entre el trait y la clase , con los siguientes metodos [:m1]")
  end

  it 'Se componen trait varios traits a una clase sin conflicto, la instancia entiende todos los mensaje definidos por los traits' do
    #este test me dice a mi que no esta tan bueno abstraerse de la implementacion, sino este test no existiria y sin embargo es super util
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
  it 'Se componen trait con una clase en conflicto, se resta el metodo conflictivo, la instancia entiende todos los mensajes definidos por el trait' do

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

    una_clase = Class.new do
      def m1
        "soy una clase"
      end
    end
    instancia = una_clase.new

    trait_compuesto = (trait_1.sumar(trait_2)).restar(:m1)
    trait_compuesto.inyectarse_en(una_clase)

    expect(instancia.m1).to eq("soy una clase")
    expect(instancia.m2).to eq("m2")
  end

end

