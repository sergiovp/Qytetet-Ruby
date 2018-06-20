#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
module ModeloQytetet
  class Casilla
      attr_reader :numero_casilla, :coste, :tipo
      attr_accessor :titulo, :num_hoteles, :num_casas
      private :titulo=
    #  private_class_method :new
    
    def initialize(numero_casilla, coste, tipo)
      @numero_casilla = numero_casilla;
      @coste = coste;
     # @num_hoteles = 0;
      #@num_casas = 0;
      @tipo = tipo;
      #@titulo = titulo;
    end
=begin   
    def self.crear_casilla_tipo(numero_casilla, coste, tipo) 
        new(numero_casilla, coste, tipo, nil);
    end
=end  
 def soy_edificable()
        return @tipo == TipoCasilla::CALLE
    end
    
    def to_s
      aux = "numero_casilla: #{@numero_casilla}, coste: #{@coste}, tipo: #{@tipo}"
      
       if(@titulo != nil)
        aux += ", num_hoteles: #{@num_hoteles}, num_casas: #{@num_casas} titulo: #{@titulo} "
       end
       return aux
    end
   
  end
end
