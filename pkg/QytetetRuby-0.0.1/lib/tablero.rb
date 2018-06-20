#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative "casilla"

module ModeloQytetet

  class Tablero
    attr_accessor :carcel, :casillas
    
    def initialize
      inicializar()
    end
    
    def inicializar() 
      @casillas = Array.new
      @casillas << Casilla.crear_casilla_tipo(0, 100, TipoCasilla::SALIDA)
      @casillas << Casilla.crear_casilla_calle(1,100, TituloPropiedad.new("UNO", 50, 10, 150, 250))
      @casillas << Casilla.crear_casilla_tipo(2,200, TipoCasilla::IMPUESTO)
      @casillas << Casilla.crear_casilla_calle(3, 100, TituloPropiedad.new("TRES", 55, 11, 235, 300))
      @casillas << Casilla.crear_casilla_calle(4, 100, TituloPropiedad.new("CUATRO", 60, 12, 320, 350))
      @carcel = Casilla.crear_casilla_tipo(5, 0, TipoCasilla::CARCEL)
      @casillas << @carcel
      @casillas << Casilla.crear_casilla_calle(6, 100, TituloPropiedad.new("SEIS", 65, 13, 405, 400))
      @casillas << Casilla.crear_casilla_tipo(7,0, TipoCasilla::SORPRESA)
      @casillas << Casilla.crear_casilla_calle(8, 100, TituloPropiedad.new("OCHO", 70, 14, 490, 450))
      @casillas << Casilla.crear_casilla_calle(9, 100, TituloPropiedad.new("NUEVE", 75, 15, 575, 500))
      @casillas << Casilla.crear_casilla_tipo(10,0, TipoCasilla::PARKING)
      @casillas << Casilla.crear_casilla_calle(11, 100, TituloPropiedad.new("ONCE", 80, 16, 660, 550))
      @casillas << Casilla.crear_casilla_tipo(12, 0, TipoCasilla::SORPRESA)
      @casillas << Casilla.crear_casilla_calle(13, 100, TituloPropiedad.new("TRECE", 85, 17, 745, 600))
      @casillas << Casilla.crear_casilla_calle(14, 100, TituloPropiedad.new("CATORCE", 90, 18, 830, 650))
      @casillas << Casilla.crear_casilla_tipo(15, 0, TipoCasilla::JUEZ)
      @casillas << Casilla.crear_casilla_calle(16, 100, TituloPropiedad.new("DIECISEIS", 95, 19, 915, 700))
      @casillas << Casilla.crear_casilla_calle(17, 100, TituloPropiedad.new("DIECISIETE", 100, 20, 1000, 750))
      @casillas << Casilla.crear_casilla_tipo(18, 0, TipoCasilla::SORPRESA)
      @casillas << Casilla.crear_casilla_calle(19, 100, TituloPropiedad.new("DIECINUEVE", 100, 20, 1000, 750))
    end
    
    def es_casilla_carcel(numero_casilla)
        rta = false
        if(numero_casilla == @carcel.numero_casilla)
            rta=true
        end
        return rta
    end
    
    def obtener_casilla_numero(numero_casilla)
      @casillas.at(numero_casilla)    
    end
    
    def obtener_nueva_casilla(casilla, desplazamiento)
      return obtener_casilla_numero((casilla.numero_casilla + desplazamiento) % @casillas.size)
    end
    
   #def getNumeroCasilla(i)
       # comprobar que este entre 0 y el tope
          #return @casillas[i] 
     #     return @casillas.at(i)
      #end
    def to_s
      "casillas: #{@casillas}, carcel: #{@carcel} \n"
    end
    
  end
end
