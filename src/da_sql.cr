
module DA_SQL
  extend self

  def inline(sql : String, *vals)
    sql.gsub(/\{\{\s*([0-9]+)\s*\}\}/) { |x, i|
      x = vals[i.captures.first.not_nil!.to_i - 1]
      case x
      when String
        clean_inline_value(x)
      when Int32, Int64
        x
      else
        raise Error.new("Invalid type for inlining: #{x.class.inspect}")
      end
    }
  end # === def sql_pair

  def clean_inline_value(x : String)
    quote_mark = nil
    x.each_char_with_index { |c, i|
      case c
      when 'a'..'z', 'A'..'Z', '_', '-', '0'..'9'
        c
      else
        case
        when i == 0 && c == '\'' || c == '"'
          quote_mark = c
          next
        when i == (x.size - 1) && c == quote_mark
          next
        end
        raise Error.new("Invalid character for inline value: #{c.inspect}")
      end
    }
    x
  end # === def clean_inline_value

  class Error < Exception
  end # === class Error

  struct Inline_Value

    getter value : String | Int32 | Int64

    def initialize(@value)
    end # === def initialize

  end # === struct Inline_Value

  struct Value

    getter value : String | Int32 | Int64

    def initialize(@value)
    end # === def initialize

  end # === struct Value

end # === module DA_SQL
