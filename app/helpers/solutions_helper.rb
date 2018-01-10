module SolutionsHelper
  def iteration_path(url_path, url_parts)
    if url_path
      send url_path, *url_parts
    else
      url_parts
    end
  end
end
