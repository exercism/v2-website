module TrackPagesHelper
  def title_for_track_page(track, page)
    case page.to_sym
    when :about
      "About the #{track.title} Track"
    when :installation
      "Installing #{track.title}"
    when :learning
      "Learning #{track.title}"
    when :tests
      "Running the Tests"
    when :resources
      "Useful #{track.title} Resources"
    end
  end
end
