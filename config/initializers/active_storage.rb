require 'active_storage/filename'
class ActiveStorage::Filename

  def with_slashes
    @filename.encode(Encoding::UTF_8, invalid: :replace, undef: :replace, replace: "�").strip.tr("\u{202E}%$|:;\t\r\n\\", "-").to_s
  end
end
