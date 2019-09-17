module PrismJsHelper
  def prism_js_theme
    if user_signed_in? && current_user.dark_code_theme
      "prism-okaidia.min.css"
    else
      "prism.min.css"
    end
  end

  def prism_js_cdn
    "//cdnjs.cloudflare.com/ajax/libs/prism/1.17.1"
  end
end
