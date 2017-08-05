class HandleValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?

    already_taken = if record.persisted?
      if record.is_a?(UserTrack)
        UserTrack.where(handle: value).where.not(id: record.id).exists? ||
        User.where(handle: value).exists?
      else
        UserTrack.where(handle: value).exists? ||
        User.where(handle: value).where.not(id: record.id).exists?
      end
    else
      UserTrack.where(handle: value).exists? ||
      User.where(handle: value).exists?
    end

    if already_taken
      record.errors[attribute] << (options[:message] || "is already taken")
    end
  end
end
