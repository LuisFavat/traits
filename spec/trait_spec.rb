
require 'rspec'
require 'trait'

describe 'interface' do
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

    trait_sin_conflicto = trait_con_conflicto.restar(:m1)

    una_clase = Class.new do
      def m1
        "hola, soy una_clase"
      end
    end
    instancia = una_clase.new

    trait_sin_conflicto.inyectarse_en(una_clase)

    expect(instancia.m1).to eq("hola, soy una_clase")
  end


end