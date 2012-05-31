
module GameLineFormattable
  def tokens_from_line(line)
    rs = line.split("{{")
    es = rs.collect {|r|
      if r =~ /}}/
        rv = r.split("}}")[0]
      else
        rv = []
      end
      rv
    }
    es.flatten.collect{|e| e.strip}

  end

  def format_line(l, dataholder=nil)
    line = "#{l}".dup
    tokens = tokens_from_line(line)

    tokens.each {|token|
      line.gsub!("{{#{token}}}", "#{game_evaluate(token, dataholder)}")
    }


    line
  end

  #TODO this is probably going to be hard to move to c++ as-is, need to get rid of obj.send() calls
  def game_evaluate(token, dataholder=nil)
    obj = @game
    token.split(".").each {|elem|
      raise "must implement #{elem} on #{obj}" unless obj.respond_to? elem
      if obj.method(elem).parameters.size == 0
        obj = obj.send(elem)
      else
        obj = obj.send(elem, dataholder.action_argument)
      end
    }
    obj
  end
    
end
