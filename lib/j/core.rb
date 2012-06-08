module J
  module_function


  NUMERAL = "(?:_)?\d+(?:\.\d+)?"
  NUMERAL_RE = /\A(#{NUMERAL})(.*)\z/

  def parse(expr)
    expr_list = Tokenizer.new(expr).tokenize
    evaluate(expr_list)
  end



  def evaluate(expr_list)
    p expr_list
    pos = expr_list.index {|token| Verb.duck(token)}
    left = expr_list[0...pos]
    right = expr_list[pos+1..-1]
    verb = expr_list[pos]
    verb.call(*left, *right)
  end



  class Numeral

    attr_reader :value

    def initialize(value=0)
      @value = value
    end

    def self.[](token)
      token = token.sub(/^_/, "-").to_f if token.is_a? String
      self.new(token)
    end

  end


  class Verb

    VERBS = {}

    def self.duck(thing)
      thing.is_a?(Class) and thing < Verb
    end

    def self.check(expr)
      if VERBS.keys.collect(&:chars).collect(&:first).include?(expr.chars.first)
        if [".", ":"].include? expr[1]
          expr[0..1]
        else
          expr[0]
        end
      else
        nil
      end
    end


    def self.symbol
      @symbol = Proc.new.call
      VERBS[@symbol] ||= self
    end

    def self.monad
      @monad = Proc.new
    end

    def self.dyad
      @dyad = Proc.new
    end


    def self.call(*args)
      case args.length
      when 1
        @monad.call(*args)
      when 2
        @dyad.call(*args)
      end
    end

    def self.[](token)
      VERBS[token]
    end


    class Times < Verb
      symbol {"*"}
      monad {|x| nil}
      dyad {|x, y| x * y}
    end

    class Plus < Verb
      symbol {"+"}
      monad {|x| nil}
      dyad {|x, y| x + y}
    end

  end
end
