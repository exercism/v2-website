class IterationFile < ApplicationRecord
  belongs_to :iteration

  before_save do
    self.file_contents_digest = self.class.generate_digest(file_contents)
  end

  def self.generate_digest(contents)
    md5 = Digest::MD5.new
    md5.update(contents)
    md5.hexdigest
  end
end
