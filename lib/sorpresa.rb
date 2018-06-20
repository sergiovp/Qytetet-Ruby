#encoding: utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative "tipo_sorpresa"

module ModeloQytetet

  class Sorpresa
    attr_reader :texto, :tipo, :valor
    def initialize(texto, tipo, valor)
      @texto= texto
      @tipo = tipo
      @valor = valor
    end
    

    def to_s
      "texto: #{@texto} \n valor: #{@valor} \n tipo: #{@tipo}"
    end



  end
end
