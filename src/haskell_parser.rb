class HaskellValueParser

  def initialize(str)
    @buffer = StringScanner.new(str)
  end

  def parse_haskell_value()
    if @buffer.check /\(/
      parse_parens()
    elsif @buffer.check /Just|Nothing/
      parse_maybe()
    elsif @buffer.check /\d/
      parse_int()
    elsif @buffer.check /True|False/
      parse_bool()
    elsif @buffer.check /\[/
      parse_list()
    elsif @buffer.check /"/
      parse_string()
    else
      parse_record()
    end
  end

  def parse_parens()
    #print "parsing parens"
    @buffer.scan /\(/ # consume opening paren
    @buffer.scan /\s+/ # consume whitespace
    v = parse_haskell_value()
    @buffer.scan /\)/ # consume closing paren
    @buffer.scan /\s+/ # consume whitespace
    v
  end

  def parse_maybe()
    #print "parsing maybe"
    if @buffer.scan /Nothing/
      nil
    else
      @buffer.scan /Just/
      @buffer.scan /\s+/ # consume whitespace
      v = parse_haskell_value()
      @buffer.scan /\s+/ # consume whitespace
      v
    end
  end

  def parse_int()
    #print "parsing int"
    i = @buffer.scan /\d+/
    @buffer.scan /\s+/ # consume whitespace
    i.to_i
  end

  def parse_bool()
    #print "parsing bool"
    if @buffer.scan /True/
      b = true
    else
      @buffer.scan /False/
      b = false
    end
    @buffer.scan /\s+/ # consume whitespace
    b
  end

  def parse_list()
    #print "parsing list"
    @buffer.scan /\[/ # consume opening bracket
#    print @buffer.peek(3)
#    return nil
    @buffer.scan /\s+/ # consume whitespace
    v = []
    while !@buffer.scan /\]/
      v.append(parse_haskell_value())
      @buffer.scan /,/ # consume a possible comma
      @buffer.scan /\s+/ # consume whitespace
    end
    @buffer.scan /\s+/ # consume whitespace
    v
  end

  def parse_string()
    #print "parsing string"
    @buffer.scan /"/ # consume opening double quotes
    s = @buffer.scan_until /"/
    @buffer.scan /\s+/ # consume whitespace
    s.chop
  end

  def parse_record()
    #print "parsing record"
    @buffer.skip /\w+/ # skip past the constructor
    @buffer.scan /\s+/ # consume whitespace
    @buffer.scan /\{/  # consume opening brace
    @buffer.scan /\s+/ # consume whitespace
    h = {}
    while !@buffer.scan /\}/
      h = h.merge(parse_record_field())
    end
    @buffer.scan /\s+/ # consume whitespace
    h
  end

  def parse_record_field()
    #print "parsing record field"
    f = @buffer.scan /\w+/
    @buffer.scan /\s+/ # consume whitespace
    @buffer.scan /\=/ # consume equals sign
    @buffer.scan /\s+/ # consume whitespace
    v = parse_haskell_value()
    @buffer.scan /,/ # consume a possible comma
    @buffer.scan /\s+/ # consume whitespace
    { "#{f}": v }
  end

  def parseNoteId()
    parse_field("_mqeNoteId")&.to_i
  end

end
