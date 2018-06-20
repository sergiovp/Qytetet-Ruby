# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
module ModeloQytetet
  
  class Especulador < Jugador

    @@factor_especulador = 2
    
    def initialize(jugador, fianza)
      super(jugador.encarcelado, jugador.nombre, jugador.saldo, jugador.casilla_actual, jugador.carta_libertad, jugador.propiedades)
      @fianza = fianza
    end
    
=begin
FALTA EL CONSTUCTOR RARO DE ESPECULADOR
=end

    def pagar_impuestos(cantidad)
      modificar_saldo(-(cantidad/2))
    end
    protectec :pagar_impuestos
    
    def ir_a_carcel(casilla)
      if pagar_fianza(fianza)
        modificar_saldo(-@fianza)
      
      else
        @casilla_actual = casilla
        @encarcelado = true
      end
      
    end
    protected :ir_a_carcel
       
    def convertirme(fianza)
      self
    end
    protected :convertirme
    
    def pagar_fianza(cantidad)
      puedo = false
      if cantidad < @saldo
        puedo = true
      end
      puedo
    end
    private :pagar_fianza

    def to_s
      aux = "Especulador{ Fianza= #{@fianza}"

       return aux
    end
    
  end
end
