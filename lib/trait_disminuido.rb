class TraitDisminuido < Trait

  def initialize(un_trait, selectores_ignorados)
    super()
    @trait = un_trait
    @selectores_ignorados = selectores_ignorados
  end

  def selectores_disponibles
    @trait.selectores_disponibles - @selectores_ignorados
  end

  def comprobar_conflictos
    @trait.comprobar_conflictos
  end

  def selectores_requeridos
    #Si se borra un metodo con requerimiento, el requerimiento no se borra solo
    # (el requerimiento deberia estar vinculado al metodo que lo requiere)
    @trait.selectores_requeridos
  end

  def metodos
    @trait.metodos
  end

  def metodos_para(un_selector)
    @trait.metodos_para(un_selector)
  end

  # Metodos de clase
  def self.mensaje_de_error_en_resta
    "No se puede restar un selector que no esta contenido en el trait"
  end
end

