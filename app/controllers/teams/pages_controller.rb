class Teams::PagesController < TeamsController
  before_action :redirect_if_signed_in!, only: [:index]

  PAGES = {
    "Terms and Conditions": :terms,
    "Privacy Policy": :privacy,
    "Exercism's Values": :values,
  }

  PAGES.each do |title, page|
    define_method page do
      markdown = Git::WebsiteContent.head.pages["#{page}.md"] || ""
      @page = page
      @page_title = title
      @content = ParsesMarkdown.parse(markdown.to_s)
      render action: "generic"
    end
  end

  # Landing page
  def index
    @tracks = Track.reorder("rand()").to_a
  end
end
