require 'kasten/version'
require 'kasten/kasten'

module Kasten
  class Box
    attr_reader :x, :y, :w, :h
    def initialize
      d = Kasten.kasten
      @x = d['x']
      @y = d['y']
      @w = d['w']
      @h = d['h']
    end

    def to_s
      "x: #{@x}, y: #{@y}, w: #{@w}, h: #{@h}"
    end
  end
end
