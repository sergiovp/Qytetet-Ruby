# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
module ModeloQytetet
  class OtraCasilla < Casilla
    attr_accessor :numeroCasilla, :coste, :titulo, :num_hoteles, :num_casas, :titulo 
    def initialize(numeroCasilla, coste, titulo)
      super(numeroCasilla, coste, TipoCasilla::CALLE)
      @coste = coste
      @num_hoteles = 0
      @num_casas = 0
      @tipo = TipoCasilla::CALLE
      @titulo = titulo
      @titulo.casilla = self
    end
    
     def self.crear_casilla_calle(numero_casilla, coste, titulo)
      new(numero_casilla, coste, titulo)
    end
    
    def se_puede_edificar_casa()
      if @@factor_especulador == 1
        podemos = @num_casas < 4
      else
        podemos = @num_casas < 8
      end
      podemos
    end
    
    def se_puede_edificar_hotel()
      if @@factor_especulador == 1
        podemos = @num_hoteles < 4
      else
        podemos = @num_hoteles < 8
      end
      podemos
    end
    
    
    
    def asignar_propietario(jugador)
      @titulo.propietario = jugador
      return @titulo
    end
    
    def calcular_valor_hipoteca()
        return @titulo.hipoteca_base + @num_casas*0.5*@titulo.hipoteca_base + @num_hoteles * @titulo.hipoteca_base
       
    end
    
    def cancelar_hipoteca()
        devolver = 0
        if(esta_hipotecada)
            @titulo.hipotecada(false)
            devolver = calcular_valor_hipoteca() * 0.10 + calcular_valor_hipoteca()
        end
        return devolver
    end
    
    def cobrar_alquiler()
      coste_alquiler_base = @titulo.alquiler_base + @num_casas * 0.5 + @num_hoteles*2
      @titulo.cobrar_alquiler(coste_alquiler_base)
      return coste_alquiler_base
    end
    
    def edificar_casa()
         @num_casas = @num_casas +1
         coste_edificar_casa = @titulo.precio_edificar
         return coste_edificar_casa
    end
    
    def edificar_hotel()
        @num_casas = 0
        coste_edificar_hotel = @titulo.precio_edificar
        @num_hoteles = @num_hoteles +1
        return coste_edificar_hotel
    end
    
    def esta_hipotecada()
      return @titulo.hipotecada()
    end
    
    def get_coste_hipoteca()
        return 0
    end
    
    def get_precio_edificar()
        return @titulo.precio_edificar
    end
    
    def hipotecar()
      @titulo.hipotecada = true
      cantidad_recibida = calcular_valor_hipoteca()
      return cantidad_recibida
    end
    
    def precio_total_comprar()
        return 0 ############################################################################################################################3
    end
    
    def propietario_encarcelado()
      return @titulo.propietario_encarcelado()
    end
    
    def se_puede_edificar_casa()
        return @num_casas < 4
    end
    
    def se_puede_edificar_hotel()
        return @num_casas==4 && @num_hoteles < 4
    end
    
   
    
    def tengo_propietario()
      return @titulo.tengo_propietario()
    end
    
    def vender_titulo()
        precio_compra = @coste + (@num_casas+ @num_hoteles) * @titulo.precio_edificar
        precio = precio_compra + @titulo.factor_revalorizacion * precio_compra
        @titulo.propietario = nil
        @num_casas = 0
        @num_hoteles= 0
        return precio
    end
    
    def asignar_titulo_propiedad() #############################################################################
      @titulo.casilla = self
    end
    private :asignar_titulo_propiedad
  end
end