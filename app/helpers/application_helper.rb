module ApplicationHelper

  def hex_turquoise_icon(track, options={})
    hex_icon("turquoise", track, options)
  end

  def hex_white_icon(track, options={})
    hex_icon("white", track, options)
  end

  def hex_green_icon(track, options={})
    hex_icon("green", track, options)
  end

  def hex_icon(colour, track, options={})
    options[:onerror] = "this.onerror=null;this.src='https://s3-eu-west-1.amazonaws.com/exercism-static/tracks/default-hex-#{colour}.png'"
    image_tag(track.send("hex_#{colour}_icon_url"), options)
  end

  def bordered_green_icon(track, options={})
    bordered_icon("green", track, options)
  end

  def bordered_turquoise_icon(track, options={})
    bordered_icon("turquoise", track, options)
  end

  def bordered_icon(colour, track, options={})
    options[:onerror] = "this.onerror=null;this.src='https://s3-eu-west-1.amazonaws.com/exercism-static/tracks/default-bordered-#{colour}.png'"
    image_tag(track.send("bordered_#{colour}_icon_url"), options)
  end

end
