module Enumerable
  def avg
    f = sum.fdiv(size)
    f.nan?? 0 : f
  end
end
