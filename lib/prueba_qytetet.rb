#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative "sorpresa"
require_relative "tipo_sorpresa"
require_relative "casilla"
require_relative "tipo_casilla"
require_relative "titulo_propiedad"
require_relative "tablero"
require_relative "qytetet"
require_relative "metodo_salir_carcel"
require_relative "jugador"
require_relative "dado"





module ModeloQytetet
  
  class PruebaQytetet
    @mazo = Array.new
    @tablero = Tablero.new
    @jugadores = Array.new
    #tablero.getCarcel().getNumeroCasilla()
    def self.inicializar_sorpresas()
      @mazo << Sorpresa.new("Te hemos pillado con chanclas y calcetines, lo sentimos, ¡Debes ir a la carcel!", @tablero.carcel.numero_casilla , TipoSorpresa::IRACASILLA)
      @mazo << Sorpresa.new("Avanza hasta la salida",0 , TipoSorpresa::IRACASILLA)
      @mazo << Sorpresa.new("Descansa un poco, avanza hasta el Parking", 10, TipoSorpresa::IRACASILLA)
      @mazo << Sorpresa.new("Un fan anónimo ha pagado tu fianza. Sales de la cárcel",  6, TipoSorpresa::SALIRCARCEL)
      @mazo << Sorpresa.new("Cada jugador debe darte 100 Euros", +100, TipoSorpresa::PORJUGADOR)
      @mazo << Sorpresa.new("Invitas a cenar a tus amigos. 50 por cabeza", -50, TipoSorpresa::PORJUGADOR)
      @mazo << Sorpresa.new("Compraste juguetes para los niños pobres en navidad", -100, TipoSorpresa::PAGARCOBRAR)
      @mazo << Sorpresa.new("Tu abuelo murió, heredas 400 Euros", 400, TipoSorpresa::PAGARCOBRAR)
      @mazo << Sorpresa.new("Multa por construcciones inseguras.", -80, TipoSorpresa::PORCASAHOTEL)
      @mazo << Sorpresa.new("Degravas el IVA en todas tus propiedades!", +70, TipoSorpresa::PORCASAHOTEL)
    
    end

    def self.get_sorpresas_positivas
      aux = Array.new
      for s in @mazo
        aux << s if s.valor>0
      end
        
       return aux
    end

    def self.get_sorpresas_ir_a_casilla
      aux = Array.new

      for s in @mazo
        aux << s  if s.tipo == TipoSorpresa::IRACASILLA
      end
      return aux
    end

    def self.get_sorpresa_tipo(t)
      aux = Array.new

      for s in @mazo
        aux << s if s.tipo == t.tipo
      end
      return aux
    end
    #sin el self es un metodo de instancia y habria que declarar
    #fuera un objeto del tipo de la clase, si pongo el self es un objeto de clase
    #y no hace falta
    def self.main()
      #ModeloQytetet.inicializar_sorpresas
      self.inicializar_sorpresas
      #puts @@mazo llamar al to_s
      #  puts "Mostramos un jugador: "
       # @jugadores << "pablo" << "sergio"
       # q = Qytetet.instance
       # q.inicializarJugadores(@jugadores)
       # puts q.inspect
        #puts "imprimo el mazooo"
        #puts @mazo
        puts "El main funciona correctamente"
    end
end
  PruebaQytetet.main

end
