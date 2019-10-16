module SqlSnippets
  def self.random
    Arel.sql("RAND()")
  end
end
