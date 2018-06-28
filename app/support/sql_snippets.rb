module SQLSnippets
  def self.random
    Arel.sql("RAND()")
  end
end
