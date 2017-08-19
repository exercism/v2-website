class HandleValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?

    check_regexp(record, attribute, value)
    check_duplicate(record, attribute, value)
  end

  def check_regexp(record, attribute, value)
    unless value =~ Exercism::Magic::HandleRegexp
      record.errors[attribute] << "most have only letters, numbers or hyphens."
    end
  end

  def check_duplicate(record, attribute, value)
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
      record.errors[attribute] << "is already taken"
    end
  end
end
