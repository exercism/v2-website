module TracksHelper

  def hex_turquoise_track_icon(track, options={})
    hex_track_icon("turquoise", track, options)
  end

  def hex_white_track_icon(track, options={})
    hex_track_icon("white", track, options)
  end

  def hex_green_track_icon(track, options={})
    hex_track_icon("green", track, options)
  end

  def bordered_green_track_icon(track, options={})
    bordered_track_icon("green", track, options)
  end

  def bordered_turquoise_track_icon(track, options={})
    bordered_track_icon("turquoise", track, options)
  end

  def hex_track_icon(color, track, options={})
    track_icon(:hex, color, track, options)
  end

  def bordered_track_icon(color, track, options={})
    track_icon(:bordered, color, track, options)
  end

  def track_icon(type, color, track, options={})
    options[:onerror] = "this.onerror=null;this.src='https://s3-eu-west-1.amazonaws.com/exercism-static/tracks/default-#{type}-#{color}.png'"
    image_tag(track.send("#{type}_#{color}_icon_url"), options)
  end

end
