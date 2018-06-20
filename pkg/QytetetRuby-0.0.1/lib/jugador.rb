#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.


module ModeloQytetet
  class Jugador
    attr_accessor :encarcelado, :nombre, :saldo, :casilla_actual, :carta_libertad, :propiedades
    
    protected
    def initialize(nombre)
      @encarcelado = false
      @nombre = nombre
      @saldo = 7500
      @casilla_actual = nil
      @carta_libertad = nil
      @propiedades = Array.new
    end
    
    protected
    def pagar_impuestos(cantidad)
    
    end
    
    protected
    def convertirme(fianza)
      
    end
    
   
    
    


    def tengo_propiedades()
     # return @propietades = saber si esta vacio
      tengo = false
      
      if(@propiedades.size() > 0)
        tengo = true
      end
      
      return tengo
      
    end
      protected
      def actualizar_posicion(casilla)
        tengo_propietario = false
      
        if(casilla.numero_casilla < @casilla_actual.numero_casilla)
          modificar_saldo(Qytetet.SALDO_SALIDA);
        end
      
        @casilla_actual = casilla;
      
        if(casilla.soy_edificable)
          tengo_propietario = casilla.tengo_propietario
        
          if(tengo_propietario)
            @encarcelado = casilla.propietario_encarcelado

            if(!encarcelado)
              if (!casilla.esta_hipotecada)
                coste_alquiler = casilla.cobrar_alquiler()
                modificar_saldo(-coste_alquiler)
              end

            end
          end
        
      elsif (casilla.tipo == TipoCasilla::IMPUESTO)
        coste = casilla.coste
        modificar_saldo(coste)
      end
      return tengo_propietario
      end
    
      def comprar_titulo()
             puedo_comprar = false
             
      if(@casilla_actual.soy_edificable)
        tengo_propietario = @casilla_actual.tengo_propietario
        
        if(!tengo_propietario)
          coste_compra = @casilla_actual.coste
          
          if(coste_compra <= @saldo)
            titulo = @casilla_actual.asignar_propietario(self)
            
            @propiedades << titulo           
            modificar_saldo(-coste_compra)
            puedo_comprar = true
          end
        end
      end
      
      puedo_comprar
      end

      def devolver_carta_libertad()
        aux = @carta_libertad
        @carta_libertad = nil
        return aux
      end

      def ir_a_carcel(casilla)
        @casilla_actual = casilla
        @encarcelado = true
      end

      def modificar_saldo(cantidad)
        @saldo += cantidad
      end
        
      def obtener_capital() #ESTA BIEN??????????????????????????????
      #  total = @saldo
      #  for p in @propiedades
      #    total += p.casilla.coste
      #    if(p.casilla.esta_hipotecada)
      #      total -= p.hipoteca_base
      #    end
      #  end
      #  return total
  capitaltotal = @saldo
      costetotal = 0
      numcasasyhoteles = cuantas_casas_hoteles_tengo()
    
        @propiedades.each do |p|
            costetotal += p.casilla.coste 
            capitaltotal = costetotal + (numcasasyhoteles * p.casilla.precio_edificar);
            if(p.hipotecada)
                capitaltotal -= p.hipoteca_base
            end
        end 
    capitaltotal;      
      end

      def obtener_propiedades_hipotecadas(hipotecada)
        aux = Array.new
        for p in propiedades
          if(hipotecada) #aniadimos las propiedades hipotecadas
            aux << p
          else #aniadimos las propiedades NO hipotecadas
            aux << p
          end
        end
        
        return aux
      end

      def pagar_cobrar_por_casa_y_hotel(cantidad)
        numero_total = cuantas_casas_hoteles_tengo()
        modificar_saldo(numero_total * cantidad)
      end

      def pagar_libertad(cantidad)
        tengo_saldo = tengo_saldo(cantidad)
        
        if(tengo_saldo)
            modificar_saldo(-cantidad)
        end
        return tengo_saldo
      end

      def puedo_edificar_casa(casilla)
        es_mia = es_de_mi_propiedad(casilla)
        tengo_saldo=false
        if(es_mia)
            costee = casilla.precio_edificar
            tengo_saldo = tengo_saldo(costee)
        end
        
        if(tengo_saldo)
          puts "ahora esdemipropiedad esta bien"
        end
        
     
     
        return tengo_saldo
      #######################3############3
      #  es_mia = es_de_mi_propiedad(casilla)
      #puedo_edificar = false
    
      #if(es_mia)
       # coste_edificar_casa = casilla.get_precio_edificar
      # tengo_saldo = tengo_saldo(coste_edificar_casa)
      #end
    
      #if(es_mia && tengo_saldo)
      # puedo_edificar = true
      #end
    
      #return puedo_edificar
      end

      def puedo_edificar_hotel(casilla)
        es_mia = es_de_mi_propiedad(casilla)
        puedo_edificar = false

        if(es_mia)
          coste_edificar_hotel = casilla.get_precio_edificar
          tengo_saldo = tengo_saldo(coste_edificar_hotel)
        end

        if(es_mia && tengo_saldo)
          puedo_edificar = true
        end

       return puedo_edificar
    end

      def puedo_hipotecar(casilla)
          es_mia = es_de_mi_propiedad(casilla)
          return es_mia
      end

      def puedo_pagar_hipoteca(casilla) 
        hipoteca = casilla.calcular_valor_hipoteca * 0.1
        puedo_pagar = false
      
        if(hipoteca < @saldo)
          puedo_pagar = true
        end
      
        return puedo_pagar
      end

      def puedo_vender_propiedad(casilla)
          es_mia = es_de_mi_propiedad(casilla)
          hipotecada = casilla.esta_hipotecada
          
          if(es_mia && !hipotecada)
              return true
          end
          return false
      end

      def tengo_carta_libertad()
          return @carta_libertad != nil
      end

      def vender_propiedad(casilla)
          precio_venta = casilla.vender_titulo()
          modificar_saldo(precio_venta)
          eliminar_de_mis_propiedades(casilla)
      end

      def cuantas_casas_hoteles_tengo()
          rta=0
          for p in @propiedades
              rta += p.casilla.num_casas + p.casilla.num_hoteles
          end
          return rta
      end
     # private :cuantas_casas_hoteles_tengo

      def eliminar_de_mis_propiedades(casilla)
          #for p in @propiedades
           #   if(p == casilla.titulo)
          #        @propiedades.delete(p)  
           #   end
          #end
          @propiedades.remove(casilla.titulo)
      end
      #private :eliminar_de_mis_propiedades
      
      def es_de_mi_propiedad(casilla)
         # for p in @propiedades
         #     if(casilla == p.casilla)
         #         return true
         #     end
         # end
          
         # return false
        return @propiedades.include?(casilla)
      end
     # private :es_de_mi_propiedad
      
      def tengo_saldo(cantidad)
          return cantidad<=@saldo
      end  
      #private :tengo_saldo
      
      def to_s
      "jugador {nombre: #{@nombre}, encarcelado: #{@encarcelado},
      saldo: #{@saldo}, casilla_actual: #{@casilla_actual}, 
      carta_libertad: #{@carta_libertad}, propiedades: #{@propiedades}} \n"
    end
  end
end