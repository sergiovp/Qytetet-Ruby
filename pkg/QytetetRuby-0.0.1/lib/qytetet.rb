#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative "dado"
require_relative "sorpresa"
require_relative "metodo_salir_carcel"
require_relative "jugador"
require_relative "tablero"
require "singleton"

module ModeloQytetet
  class Qytetet
    #para crear un objeto sigleton de ruby Qytetet.instance
    include Singleton
    attr_accessor :MAX_JUGADORES, :MAX_CARTAS, :MAX_CASILLAS, :PRECIO_LIBERTAD, :SALDO_SALIDA, :mazo, :dado
    attr_accessor :carta_actual
    attr_accessor :jugador_actual
    attr_accessor :tablero
    attr_accessor :jugadores
     @@MAX_JUGADORES = 4
     @@MAX_CARTAS=10
     @@MAX_CASILLAS =20
     @@PRECIO_LIBERTAD = 200
     @@SALDO_SALIDA = 1000
   
     def initialize()
      @mazo = Array.new
      @carta_actual = nil
      @jugador_actual = nil
      @tablero = nil
      @jugadores = nil
      @dado  = Dado.instance
    end
    
    def aplicar_sorpresa()
        tiene_propietario = false
        es_carcel =false
        
        if(@carta_actual.tipo == TipoSorpresa::PAGARCOBRAR)
            @jugador_actual.modificar_saldo(@carta_actual.valor)
        
        elsif(@carta_actual.tipo == TipoSorpresa::IRACASILLA)
            es_carcel = @tablero.es_casilla_carcel(@carta_actual.valor)
            
            if(es_carcel)
                encarcelar_jugador()
            else
                nueva_casilla = @tablero.obtener_casilla_numero(@carta_actual.valor)
                @jugador_actual.actualizar_posicion(nueva_casilla)
                return tiene_propietario
            end
        
        elsif(@carta_actual.tipo == TipoSorpresa::PORCASAHOTEL)
            @jugador_actual.pagar_cobrar_por_casa_y_hotel(@carta_actual.valor)
        
        elsif(@carta_actual.tipo == TipoSorpresa::PORJUGADOR)
            for j in @jugadores
                if(j != @jugador_actual)
                    j.modificar_saldo(+@carta_actual.valor)
                    @jugador_actual.modificar_saldo(-@carta_actual.valor)
                end
            end
          elsif(@carta_actual.tipo == TipoSorpresa::CONVERTIRME)
             @jugador_actual.convertirme(@carta_actual.getValor()); #DEVUELVE UN ESPECULADOR
                      #  System.out.println("Es de tipo convertirme");
        end
        
        if(@carta_actual.tipo == TipoSorpresa::SALIRCARCEL)
            @jugador_actual.carta_libertad = @carta_actual
        else
            @mazo << @carta_actual
        end

        return tiene_propietario
    end

    def cancelar_hipoteca(casilla) #########################################################################################
       puedo_cancelar = false
      
      if (casilla.soy_edificable)
        se_puede_cancelar = casilla.esta_hipotecada
        
        if (se_puede_cancelar)
          puedo_cancelar = @jugador_actual.puedo_pagar_hipoteca(casilla)

          if (puedo_cancelar)
            coste_cancelar = casilla.cancelar_hipoteca
            @jugador_actual.modificar_saldo(-coste_cancelar)
          end
        end
      end
      
      puedo_cancelar
    end

    def comprar_titulo_propiedad()
        return @jugador_actual.comprar_titulo()
    end

     def edificar_casa(casilla)
         puedo_edificar = false
         if(casilla.soy_edificable())
             se_puede_edificar = casilla.se_puede_edificar_casa()
             if(se_puede_edificar)
                 puedo_edificar = @jugador_actual.puedo_edificar_casa(casilla)
                 
                 if(puedo_edificar)
                     coste_edificar_casa = casilla.edificar_casa()
                     
                     @jugador_actual.modificar_saldo(-coste_edificar_casa)
                     
                 end
             end
         end
         return puedo_edificar
     end

     def edificar_hotel(casilla)
        puedo_edificar = false;
        if(casilla.soy_edificable())
            se_puede_edificar= casilla.se_puede_edificar_hotel()
            if(se_puede_edificar)
                puedo_edificar = @jugador_actual.puedo_edificar_hotel(casilla)
                if(puedo_edificar)
                   coste_edificar_hotel= casilla.edificar_hotel(); #es una copia de la casilla por tanto llamando a edificar_hotel, no aumenta el numero de hoteles
                   #solo funciona como booleano 
                   for i in  @jugador_actual.propiedades
                       if(i == casilla)
                         i.casilla.num_hoteles = i.casilla.num_hoteles +1
                       end
                     end
                   @jugador_actual.modificar_saldo(-coste_edificar_hotel);
                end
            end
        end
        return puedo_edificar; #DUDA
     end

      
      def hipotecar_propiedad(casilla)
          puedo_hipotecar = false
          
          if(@casilla.soy_edificable())
              se_puede_hipotecar = !casilla.esta_hipotecada()
              if(se_puede_hipotecar)
                  puedo_hipotecar=@jugador_actual.puedo_hipotecar(casilla)
                  
                  if(puedo_hipotecar)
                      cantidad_recibida = casilla.hipotecar()
                      @jugador_actual.modificar_saldo(cantidad_recibida)
                  end
              end
          end
          return puedo_hipotecar
      end

      def inicializar_juego(nombres)
            inicializar_tablero()
            inicializar_cartas_sorpresa()

          inicializar_jugadores(nombres)
          salida_jugadores()
      end

      def intentar_salir_carcel(metodo)
          libre =false
          if(metodo == MetodoSalirCarcel::TIRANDODADO)
              libre = @dado.tirar() > 5
          
          
          elsif(metodo == MetodoSalirCarcel::PAGANDOLIBERTAD)
             libre  = @jugador_actual.pagar_libertad(@@PRECIO_LIBERTAD)
                 
          end
          
          if(libre)
              @jugador_actual.encarcelado = false
          end
          return libre
      end

      def jugar()
          valor_dado = @dado.tirar()
          casilla_posicion = @jugador_actual.casilla_actual
          nueva_casilla = @tablero.obtener_nueva_casilla(casilla_posicion, valor_dado)
          tiene_propietario = @jugador_actual.actualizar_posicion(nueva_casilla)
          
          if(!nueva_casilla.soy_edificable())
              if(nueva_casilla.tipo == TipoCasilla::JUEZ)
                  encarcelar_jugador()
              
              elsif(nueva_casilla.tipo == TipoCasilla::SORPRESA)
                 # @carta_actual = @mazo[0]
                @cartaActual = @mazo.delete_at(0)
              end
          end
          return tiene_propietario
      end

      def obtener_ranking()
          
        ranking = {}

        jugadores = @jugadores.sort { |j1,j2| j2.obtener_capital - j1.obtener_capital }

        jugadores.each do |jugador|
          capital = jugador.obtener_capital
          ranking[jugador.nombre] = capital
        end

        return ranking      
            
      end

      def propiedades_hipotecadas_jugador(hipotecadas)
        casillas = Array.new
        propiedades = @jugador_actual.obtener_propiedades_hipotecadas(hipotecadas)
      
      for item in @tablero.casillas
        for aux in propiedades
          if (aux == item.titulo)
            casillas << item
          end
        end
      end
      
      return casillas
      end

      def siguiente_jugador()
        pos = 0
        long = @jugadores.length
      
        for i in 0..long
          if (@jugador_actual == @jugadores.at(i))
            pos = i
          end
        end
      
        @jugador_actual = @jugadores.at((pos + 1) % long)
      
        return @jugador_actual
      end

      def vender_propiedad(casilla)
          puedo_vender = false
          if (casilla.soy_edificable())
              puedo_vender = @jugador_actual.puedo_vender_propiedad(casilla)
              if(puedo_vender)
                  @jugador_actual.vender_propiedad(casilla)
              end
          end
          return puedo_vender
      end

        def encarcelar_jugador()
          if(!@jugador_actual.tengo_carta_libertad())
              casilla_carcel = @tablero.carcel
              @jugador_actual.ir_a_carcel(casilla_carcel)
          else
              carta = @jugador_actual.devolver_carta_libertad()
              @mazo << carta
          end
        end

      def inicializar_cartas_sorpresa()
        @mazo =  Array.new
     
        @mazo << Sorpresa.new("Te hemos pillado con chanclas y calcetines, lo sentimos, ¡Debes ir a la carcel!", 5 , TipoSorpresa::IRACASILLA)
        @mazo << Sorpresa.new("Avanza hasta la salida",0 , TipoSorpresa::IRACASILLA)
        @mazo << Sorpresa.new("Descansa un poco, avanza hasta el Parking", 10, TipoSorpresa::IRACASILLA)
        @mazo << Sorpresa.new("Un fan anónimo ha pagado tu fianza. Sales de la cárcel",  6, TipoSorpresa::SALIRCARCEL)
        @mazo << Sorpresa.new("Cada jugador debe darte 100 Euros", +100, TipoSorpresa::PORJUGADOR)
        @mazo << Sorpresa.new("Invitas a cenar a tus amigos. 50 por cabeza", -50, TipoSorpresa::PORJUGADOR)
        @mazo << Sorpresa.new("Compraste juguetes para los niños pobres en navidad", -100, TipoSorpresa::PAGARCOBRAR)
        @mazo << Sorpresa.new("Tu abuelo murió, heredas 400 Euros", 400, TipoSorpresa::PAGARCOBRAR)
        @mazo << Sorpresa.new("Multa por construcciones inseguras.", -80, TipoSorpresa::PORCASAHOTEL)
        @mazo << Sorpresa.new("Degravas el IVA en todas tus propiedades!", +70, TipoSorpresa::PORCASAHOTEL)
        @mazo << Sorpresa.new("Conviertemee1 de3000", 3000, TipoSorpresa::CONVERTIRME);
        @mazo << Sorpresa.new("Conviertemee2 de 5000", 5000, TipoSorpresa::CONVERTIRME);
      end
      
      private :inicializar_cartas_sorpresa
     
      def inicializar_jugadores(nombres)
        #@jugadores = Array.new
        #for j in nombres
        #  @jugadores << Jugador.new(j)
        #end
          if (nombres.length < 2 || nombres.length > @@MAX_JUGADORES)
           raise ArgumentError, "Número incorrecto de jugadores."
         end

         @jugadores = Array.new

         for jugador in nombres
           @jugadores << Jugador.new(jugador)
         end
      end
      
       private :inicializar_jugadores

      def inicializar_tablero()
        @tablero =Tablero.new
      end
      private :inicializar_tablero
      
      def salida_jugadores()
            
      @jugadores.each do|j|
        j.casilla_actual = @tablero.obtener_casilla_numero(0)
      end
      
      @jugador_actual = @jugadores.at(rand(@jugadores.length))
      end
      private :salida_jugadores
      
      def to_s
        return   "Qytetet{ MAX_JUGADORES=  #{@MAX_JUGADORES}, MAX_CARTAS: #{@MAX_CARTAS}, MAX_CASILLAS: #{@MAX_CASILLAS}, PRECIO_LIBERTAD: #{@PRECIO_LIBERTAD}, 
            SALDO_SALIDA: #{@SALDO_SALIDA}, mazo: #{@mazo}, cartaactual: #{@carta_actual}, jugadoractual: #{@jugador_actual}, tablero: #{@tablero}, jugadores: #{@jugadores}, 
            dado: #{@dado} \n"
      end

      end
end

