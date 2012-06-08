require 'state_machine'

module J
  class Tokenizer

    def initialize(expr)
      @data = expr.chars
      @current_token = ""
      @parsed = []
      super()
    end

    def go
      @data.each do |ch|
        ev = event_for(ch)
        send ev if ev
        @current_token += ch
      end
      store_token
      @parsed.compact
    end

    alias :tokenize :go

    def store_token
      tok = case tok_state_name
      when :numeric then convert_to_numeric(@current_token)
      when :idle then nil
      when :verb then Verb[@current_token]
      else @current_token
      end
      # puts "Storing token #{@current_token.inspect} as #{tok.inspect}" if tok
      @parsed << tok if tok
      @current_token = ""
    end

    def convert_to_numeric(token)
      t = token.sub(/\A_/, "-")
      decimal_pos = t.index(".")
      if decimal_pos.nil? or decimal_pos == t.size - 1
        t.to_i
      else
        t.to_f
      end
    end

    state_machine :tok_state, :initial => :idle do

      before_transition :do => :store_token

      event :verb_char do
        transition all => :verb
      end
      event :colon do    # : .
        # transition :verb => :verb_complete
      end
      event :numeral do        # 0..9
        transition all - :numeric => :numeric
      end
      event :dot # do  # .
        # transition :verb => :verb_complete
      # end
      event :underscore do       # _
        transition all - :numeric => :numeric
      end
      event :adverb
      event :space do
        transition all => :idle
      end

    end

    def event_for(ch)
      case ch
      when /\d/ then :numeral if can_numeral?
      when "_" then :underscore if can_underscore?
      when ":" then :colon if can_colon?
      when "." then :dot if can_dot?
      when " " then :space!
      else :verb_char!
      end
    end




  end
end
