module Wilderpeople
  class Matcher

    def exact(a,b)
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
  end
end
