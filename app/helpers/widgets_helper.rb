module WidgetsHelper
  def maintainer_widget(maintainer)
    cache_widget("maintainer", maintainer) do
      render("widgets/maintainer", maintainer: maintainer)
    end
  end

  def mentor_widget(mentor)
    cache_widget("mentor", mentor) do
      render("widgets/mentor", mentor: mentor)
    end
  end

  def contributor_widget(contributor)
    cache_widget("contributor", contributor) do
      render("widgets/contributor", contributor: contributor)
    end
  end

  def cache_widget(key, object, &block)
    cache_key = "helpers/widgets/#{key}_#{object.id}_#{object.updated_at}"
    Rails.cache.fetch(cache_key) do
      block.call
    end
  end
end
