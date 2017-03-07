module Wilderpeople
  class Matcher

    def exact(a,b)
      prep(a,b)
      a == b
    end

    def transposed(a,b)
      return true if exact(a,b)
      exact *[a,b].collect{|x| x.chars.sort}
    end

    def exact_except_last_word(a,b)
      return true if exact(a,b)
      words = [a,b].collect(&:split)
      exact *words.collect{|w| w.size == 1 ? w : w[0..-2]}
    end

    def first_letter(a,b)
      return true if exact(a,b)
      exact *[a,b].collect{|x| x[0]}
    end

    def exact_no_space(a,b)
      return true if exact(a,b)
      exact *[a,b].collect{|x| x.gsub(/\s/, '')}
    end

    def prep(*args)
      args.each do |a|
        case a
        when String
          a.downcase!
        when Array
          a.collect{|x| prep(x)}
        else
          a
        end
      end
    end
  end
end
