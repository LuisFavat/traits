class TraitDisminuido < TraitAbstracto

  def initialize(un_trait, selectores_ignorados)
    super()
    @trait = un_trait
    @selectores_ignorados = selectores_ignorados
  end

  def selectores_disponibles
    @trait.selectores_disponibles - selectores_ignorados
  end

  def selectores_ignorados
    @trait.selectores_ignorados + @selectores_ignorados
  end

  def selectores_requeridos
    #Si se borra un metodo con requerimiento, el requerimiento no se borra solo
    # (el requerimiento deberia estar vinculado al metodo que lo requiere)
    @trait.selectores_requeridos
  end

  def metodos
    @trait.metodos
  end

  def metodo(un_selector)
    @trait.metodo(un_selector)
  end

  # Metodos de clase
  def self.mensaje_de_error_en_resta
    "No se puede restar un selector que no esta contenido en el trait"
  end
end

