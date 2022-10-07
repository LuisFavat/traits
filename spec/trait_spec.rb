
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
end