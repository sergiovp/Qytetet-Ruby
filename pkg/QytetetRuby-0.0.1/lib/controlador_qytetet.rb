#encoding :utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative "tipo_sorpresa"
require_relative "sorpresa"
require_relative "casilla"
require_relative "tablero"
require_relative "titulo_propiedad"
require_relative "tipo_casilla"
require_relative "qytetet"
require_relative "metodo_salir_carcel"
require_relative "jugador"
require_relative "dado"
require_relative "vista_textual_qytetet"

module InterfazTextualQytetet
  
  class ControladorQytetet
    
    include ModeloQytetet
    
    def initialize
    end
    
    def inicializacion_juego
      @vista = VistaTextualQytetet.new  
      @juego = Qytetet.instance
      
      nombres = Array.new
      nombres = @vista.obtener_nombre_jugadores
      
      @juego.inicializar_juego(nombres)
      @jugador = @juego.jugador_actual
      @casilla = @jugador.casilla_actual
      
      @vista.mostrar("---------------- JUEGO -------------")
      @vista.mostrar(@juego.to_s)
      puts "-----------------------------------------------------------------"
      @vista.esperar
    end
    
    def desarrollo_juego
      fin_juego = false
      
      while (!fin_juego)
        @vista.mostrar("Turno de " + @jugador.nombre + "\nInformacion del jugador:")
        @vista.mostrar(@jugador.to_s)
        puts "-----------------------------------------------------------------"
        @vista.esperar
        @vista.mostrar("Informacion de la casilla actual:\n#{@casilla}")
        puts "-----------------------------------------------------------------"
        @vista.esperar
        
        # Comprobamos el estado del jugador
        # antes de continuar
        libre = !@jugador.encarcelado
        
        if (!libre)
          @vista.mostrar("El jugador #{@jugador.nombre} esta encarcelado")
          puts "-----------------------------------------------------------------"
          @vista.esperar
          saldo_anterior = @jugador.saldo
          metodo = @vista.menu_salir_carcel
          if (metodo == 0)
            libre = @juego.intentar_salir_carcel(MetodoSalirCarcel::TIRANDODADO)
          else
            libre = @juego.intentar_salir_carcel(MetodoSalirCarcel::PAGANDOLIBERTAD)
          end
          @vista.mostrar("El jugador " + (libre ? "ha" : "NO ha") + " logrado salir de la carcel")
          puts "-----------------------------------------------------------------"
          @vista.esperar
          
          if (libre && @jugador.saldo != saldo_anterior)
            @vista.mostrar("El saldo del jugador #{@jugador.nombre} se ha visto afectado.")
            @vista.mostrar("Saldo Anterior: #{saldo_anterior} -> Saldo Actual: #{@jugador.saldo}")
            @vista.mostrar("Ha habido una diferencia de #{saldo_anterior - @jugador.saldo}")
            puts "-----------------------------------------------------------------"
            @vista.esperar
          end
        end
        
        if (libre)
          @vista.mostrar("#{@jugador.nombre} tira el dado")
          puts "-----------------------------------------------------------------"
          @vista.esperar
          saldo_anterior = @jugador.saldo
          no_tiene_propietario = @juego.jugar
          actualizar_casilla
          
          @vista.mostrar("#{@jugador.nombre} se desplaza hasta la casilla numero #{@casilla.numero_casilla}")
          puts "-----------------------------------------------------------------"
          @vista.esperar
          
          comprobar_cambio_saldo(saldo_anterior)
          
          if (@jugador.encarcelado)
            @vista.mostrar("El jugador ha sido enviado a la cárcel por el juez")
            puts "-----------------------------------------------------------------"
            @vista.esperar            
          end
          
          @vista.mostrar("Información de la casilla:\n#{@casilla.to_s}")
          puts "-----------------------------------------------------------------"
          @vista.esperar
          
          if (!bancarrota)
            if (!@jugador.encarcelado)
              if (@casilla.tipo == TipoCasilla::CALLE)
                if (!no_tiene_propietario)
                  @vista.mostrar("La casilla actual se puede adquirir")
                  puts "-----------------------------------------------------------------"
                  @vista.esperar
                  quiero_comprar = @vista.elegir_quiero_comprar
                  saldo_anterior = @jugador.saldo
                  @vista.mostrar("El jugador " + (quiero_comprar ? "desea" : "no desea") + " adquirir la propiedad")
                  @vista.mostrar("El saldo actual de #{@jugador.nombre} es #{saldo_anterior}")
                  puts "-----------------------------------------------------------------"
                  @vista.esperar

                  if (quiero_comprar)
                    comprado = @juego.comprar_titulo_propiedad() #################################### antes eraa                     comprado = @juego.comprar_titulo_propiedad(@casilla)

                    
                    if (comprado == true)
                      @vista.mostrar("Gracias por la compra.")
                      @vista.mostrar("El saldo de #{@jugador.nombre} se ha quedado en #{@jugador.saldo}")
                      @vista.mostrar("El importe ha sido de #{saldo_anterior - @jugador.saldo}")
                      puts "-----------------------------------------------------------------"
                      @vista.esperar
                      
                    else
                      @vista.mostrar("Desgraciadamente no se ha podido comprar la propiedad porque no se disponia de suficiente dinero.")
                      puts "-----------------------------------------------------------------"
                      @vista.esperar
                    end
                  end
                end
              
              elsif (@casilla.tipo == TipoCasilla::SORPRESA)
                @vista.mostrar("Has caido en una casilla de tipo sorpresa!")
                @vista.mostrar("La carta que se va activar es la siguiente")
                @vista.mostrar(@juego.carta_actual)
                puts "-----------------------------------------------------------------"
                @vista.esperar
                carta_liber_anterior = @jugador.tengo_carta_libertad
                saldo_anterior = @jugador.saldo
                no_tiene_propietario = @juego.aplicar_sorpresa
              
                #Actualizar la posicion actual de ser necesario
                if (@casilla != @jugador.casilla_actual)
                  actualizar_casilla
                  @vista.mostrar("#{@jugador.nombre} se desplaza hasta la casilla numero #{@casilla.numero_casilla}")
                  @vista.mostrar("Información de la casilla:\n#{@casilla.to_s}")
                  puts "-----------------------------------------------------------------"
                  @vista.esperar
                end
                
                if (@jugador.encarcelado)
                  @vista.mostrar("El jugador ha sido mandado a la cárcel por una carta sorpresa")
                  puts "-----------------------------------------------------------------"
                  @vista.esperar
                end
                
                if (carta_liber_anterior != @jugador.tengo_carta_libertad)
                  if (@jugador.tengo_carta_libertad)
                    @vista.mostrar("El jugador #{@jugador.nombre} ha cogido una carta de libertad y se la ha guardado")
                    
                  else
                    @vista.mostrar("El #{@jugador.nombre} ha evitado ir a la carcel usando su carta de libertad y la devuelve al mazo")
                  end
                  puts "-----------------------------------------------------------------"
                  @vista.esperar
                end
                
                comprobar_cambio_saldo(saldo_anterior)              

                if (!bancarrota)
                  if (!@jugador.encarcelado)
                    if (@casilla.tipo == TipoCasilla::CALLE)
                      if (!no_tiene_propietario)
                        @vista.mostrar("La casilla actual se puede adquirir")
                        quiero_comprar = @vista.elegir_quiero_comprar
                        saldo = @jugador.saldo
                        @vista.mostrar("El saldo actual de #{@jugador.nombre} es #{saldo}")
                        
                        if (quiero_comprar)
                          comprado = @juego.comprar_titulo_propiedad(@casilla)
                          
                          if (comprado)
                            @vista.mostrar("Gracias por la compra.")
                            @vista.mostrar("El saldo de #{@jugador.nombre} se ha quedado en #{@jugador.saldo}")
                            @vista.mostrar("El importe ha sido de #{saldo - @jugador.saldo}")
                            puts "-----------------------------------------------------------------"
                            @vista.esperar                      
                          else
                            @vista.mostrar("Desgraciadamente no se ha podido comprar la propiedad porque no se disponia de suficiente dinero.")
                            puts "-----------------------------------------------------------------"
                            @vista.esperar
                          end
                        end
                      end
                    end
                  end
                end
              end
              

              if (!@jugador.encarcelado && !bancarrota && @jugador.tengo_propiedades)
                opcion = @vista.menu_gestion_inmobiliaria
                
                while (opcion != 0 && @jugador.tengo_propiedades)
                  casilla = elegir_propiedad(@jugador.propiedades)
                  @vista.mostrar("Se van a realizar operaciones sobre la siguiente casilla:")
                  @vista.mostrar(@casilla.to_s)
                  saldo_actual = @jugador.saldo
                  
                  if (opcion == 1)
                    @vista.mostrar("El jugador #{@jugador.nombre} ha decidido edificar una casa. Actualmente tenia #{@casilla.num_casas} casas")
                    @vista.mostrar("Saldo actual: #{saldo_actual}")
                    @vista.esperar
                    edificado = @juego.edificar_casa(@casilla)
                    
                    
                    if (edificado)
                      @vista.mostrar("Gracias por la compra. El precio de la edificacion ha sido #{@jugador.saldo - saldo_actual}")
                      @vista.mostrar("El saldo actual es #{@jugador.saldo} y el numero de casas ha pasado a ser #{@casilla.num_casas}")
                    else
                      @vista.mostrar("Desgraciadamente no se ha podido edificar una nueva casa. No dispones del suficiente dinero o ya se ha llegado al máximo de casas posible.")
                    end
                    
                  elsif (opcion == 2)

                    @vista.mostrar("El jugador #{@jugador.nombre} ha decidido edificar un hotel. Actualmente tenia #{@casilla.num_hoteles} hoteles")
                    @vista.mostrar("Saldo actual: #{saldo_actual}")
                    puts "-----------------------------------------------------------------"
                    @vista.esperar
                    edificado = @juego.edificar_hotel(@casilla)
                    
                    if (edificado)
                      @vista.mostrar("Gracias por la compra. El precio de la compra ha sido #{@jugador.saldo - saldo_actual}")
                      @vista.mostrar("El saldo actual es #{@jugador.saldo}. El numero de casas ha pasado a ser #{@casilla.num_casas} y el numero de hoteles a ser #{@casilla.num_hoteles}")
                    else
                      @vista.mostrar("Desgraciadamente no se ha podido edificar un nuevo hotel. No dispones del suficiente dinero, ya se ha llegado al máximo de hoteles o no dispones de suficientes casas.")
                    end
                    
                  elsif (opcion == 3)
                    @vista.mostrar("El jugador ha decidido vender la propiedad.")
                    @vista.mostrar("El saldo actual del jugador es de #{saldo_actual}")
                    puts "-----------------------------------------------------------------"
                    @vista.esperar
                    vendido = @juego.vender_propiedad(@casilla)
                    
                    if (vendido)
                      @vista.mostrar("El jugador ha conseguido vender la propiedad por un importe total de #{@jugador.saldo - saldo_actual}")
                      @vista.mostrar("El saldo del jugador se ha quedado en #{@jugador.saldo}")
                    else
                      @vista.mostrar("No se ha podido vender la propiedad ya que o no se posee o está hipotecada")
                    end
                    
                  elsif (opcion == 4)
                    @vista.mostrar("El jugador ha decidido hipotecar la propiedad")
                    @vista.mostrar("El saldo actual del jugador es de #{saldo_actual}")
                    puts "-----------------------------------------------------------------"
                    @vista.esperar
                    hipotecar = @juego.hipotecar_propiedad(@casilla)
                    
                    if (hipotecar)
                      @vista.mostrar("El jugador ha conseguido hipotecar la propiedad por un importe total de #{@jugador.saldo - saldo_actual}")
                      @vista.mostrar("El saldo actual del jugador es #{@jugador.saldo}")
                    else
                      @vista.mostrar("No se ha podido hipotecar la propiedad, bien porque ya está hipotecada o porque no se posee")
                    end
                    
                  elsif (opcion == 5)
                    cancelar = @juego.cancelar_hipoteca(@casilla)
                    @vista.mostrar("El jugador ha decidido cancelar la hipoteca de la propiedad")
                    @vista.mostrar("El saldo actual del jugador es de #{saldo_actual}")
                    puts "-----------------------------------------------------------------"
                    @vista.esperar
                    if (cancelar)
                      @vista.mostrar("El jugador ha conseguido cancelar la hipoteca de la propiedad por un importe total de #{@jugador.saldo - saldo_actual}")
                      @vista.mostrar("El saldo actual del jugador es #{@jugador.saldo}")
                    else
                      @vista.mostrar("No se ha podido cancelar la hipoteca de la propiedad, bien porque ya está hipotecada o porque no se posee")
                    end
                    
                  end
                  puts "-----------------------------------------------------------------"
                  @vista.esperar
                  @vista.mostrar("Informacion de como ha quedado la casilla:")
                  @vista.mostrar(@casilla.to_s)
                  puts "-----------------------------------------------------------------"
                  @vista.esperar
                  @vista.mostrar("Estado actual del jugador:")
                  @vista.mostrar(@jugador.to_s)
                  puts "-----------------------------------------------------------------"
                  @vista.esperar
                  
                  if (@jugador.tengo_propiedades)
                    opcion = @vista.menu_gestion_inmobiliaria
                  end                  
                end
              end
            end            
          end
        end
        
        if (!bancarrota)
          @vista.mostrar("Cambio de turno. Le toca al siguiente jugador.")
          puts "-----------------------------------------------------------------"
          @vista.esperar
          cambio_turno
        end
        
        if (bancarrota)
          fin_juego = true
        end
      end
      
      puts "ey me he salido"
      
      @vista.mostrar("Fin de la partida!")
      @vista.mostrar("A continuación puedes consultar los marcadores")
      @vista.esperar
      ranking = @juego.obtener_ranking
      @vista.mostrar(ranking)
      @vista.esperar
      @vista.mostrar("Muchas gracias por jugar. Esperamos que os hayáis divertido y volváis a jugar pronto! :)")
    end
    
    def cambio_turno()
      @jugador = @juego.siguiente_jugador

       actualizar_casilla 
    end
    
    def bancarrota
      return @jugador.saldo <= 0
    end
    
    def actualizar_casilla
      @casilla = @jugador.casilla_actual
    end
    
    def comprobar_cambio_saldo(saldo_anterior)
      if (saldo_anterior != @jugador.saldo)
        if (@casilla.soy_edificable && @casilla.tengo_propietario)
          @vista.mostrar("El jugador #{@jugador.nombre} ha caido en la casilla de #{@casilla.titulo.propietario.nombre} y le tiene que pagar")

        elsif (@casilla.tipo == TipoCasilla::IMPUESTO)
          @vista.mostrar("El jugador #{@jugador.nombre} ha caido en una casilla de impuesto")

        elsif (@casilla.tipo == TipoCasilla::SALIDA)
          @vista.mostrar("El jugador #{@jugador.nombre} ha pasado por la salida y su saldo se ha visto modificado")
        elsif (@casilla.tipo == TipoCasilla::SORPRESA)
          @vista.mostrar("El jugador #{@jugador.nombre} ha caido en una casilla sorpresa y su saldo se ha visto modificado")
        end
        @vista.esperar

        @vista.mostrar("El saldo del jugador #{@jugador.nombre} se ha visto afectado.")
        @vista.mostrar("Saldo Anterior: #{saldo_anterior} -> Saldo Actual: #{@jugador.saldo}")
        @vista.mostrar("Ha habido una diferencia de #{@jugador.saldo - saldo_anterior}")
        @vista.esperar
      end
    end
    
    
    def elegir_propiedad(propiedades) # lista de propiedades a elegir
      @vista.mostrar("\tCasilla\tTitulo");
       
      listaPropiedades= Array.new
      
      propiedades.each do |prop|
      # crea una lista de strings con numeros y nombres de propiedades
        propString= @casilla.numero_casilla.to_s + ' ' + prop.nombre;  
        listaPropiedades<<propString
        
      end
      
      seleccion=@vista.menu_elegir_propiedad(listaPropiedades)  # elige de esa lista del menu
      
      propiedades.at(seleccion)
    end
    
    def self.main
      controlador = ControladorQytetet.new
      controlador.inicializacion_juego
      controlador.desarrollo_juego
    end
    
    private :bancarrota, :cambio_turno, :actualizar_casilla, :comprobar_cambio_saldo
  end
  
    ControladorQytetet.main

end