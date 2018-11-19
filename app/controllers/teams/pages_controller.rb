class Teams::PagesController < Teams::BaseController
  skip_before_action :authenticate_user!

  before_action :redirect_if_signed_in!, only: [:index]

  PAGES = {
    "Terms of Service": :terms_of_service,
    "Privacy Policy": :privacy,
    "Exercism's Values": :values,
  }

  PAGES.each do |title, page|
    define_method page do
      markdown = Git::WebsiteContent.head.pages["#{page}.md"] || ""
      @page = page
      @page_title = title
      @content = ParseMarkdown.(markdown.to_s)
      render action: "generic"
    end
  end

  # Landing page
  def index
    @tracks = Track.active.reorder("rand()").to_a
  end
end
