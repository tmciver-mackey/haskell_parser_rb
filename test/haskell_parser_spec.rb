require 'rspec'
require_relative '../src/haskell_parser.rb'

RSpec.describe HaskellValueParser do
  describe "parse a Haskell value" do

    it "parses a string" do
      s = "\"Hello world!\""
      expected = "Hello world!"
      parser = HaskellValueParser.new(s)
      parsed = parser.parse_string
      expect(parsed).to eq(expected)
    end

    it "parses an integer" do
      s = "123"
      expected = 123
      parser = HaskellValueParser.new(s)
      parsed = parser.parse_int
      expect(parsed).to eq(expected)
    end

    it "parses True as boolean" do
      s = "True"
      expected = true
      parser = HaskellValueParser.new(s)
      parsed = parser.parse_bool
      expect(parsed).to eq(expected)
    end

    it "parses False as boolean" do
      s = "False"
      expected = false
      parser = HaskellValueParser.new(s)
      parsed = parser.parse_bool
      expect(parsed).to eq(expected)
    end

    it "parses a maybe (Nothing)" do
      s = "Nothing"
      expected = nil
      parser = HaskellValueParser.new(s)
      parsed = parser.parse_maybe
      expect(parsed).to eq(expected)
    end

    it "parses a maybe int" do
      s = "Just 1"
      expected = 1
      parser = HaskellValueParser.new(s)
      parsed = parser.parse_maybe
      expect(parsed).to eq(expected)
    end

    it "parses a maybe string" do
      s = "Just \"hello\""
      expected = "hello"
      parser = HaskellValueParser.new(s)
      parsed = parser.parse_maybe
      expect(parsed).to eq(expected)
    end

    it "parses a list of ints" do
      s = "[1, 2, 3]"
      expected = [1, 2, 3]
      parser = HaskellValueParser.new(s)
      parsed = parser.parse_list
      expect(parsed).to eq(expected)
    end

    it "parses a list of string" do
      s = "[\"hello\", \"world\"]"
      expected = ["hello", "world"]
      parser = HaskellValueParser.new(s)
      parsed = parser.parse_list
      expect(parsed).to eq(expected)
    end

    it "parses a parenthesized value" do
      s = "(123)"
      expected = 123
      parser = HaskellValueParser.new(s)
      parsed = parser.parse_parens
      expect(parsed).to eq(expected)
    end

    it "parses a record" do
      s = "A { foo = 1, bar = \"hello\", baz = [1, 2, 3] }"
      expected = {"foo": 1, "bar": "hello", "baz": [1, 2, 3]}
      parser = HaskellValueParser.new(s)
      parsed = parser.parse_record
      expect(parsed).to eq(expected)
    end

    it "parses a nested record" do
      s = "A { foo = 1, bar = \"hello\", baz = [1, 2, 3], abc = B { a = \"world\", b = Just 3 } }"
      expected = {"foo": 1, "bar": "hello", "baz": [1, 2, 3], "abc": {"a": "world", "b": 3}}
      parser = HaskellValueParser.new(s)
      parsed = parser.parse_record
      expect(parsed).to eq(expected)
    end

  end
end
