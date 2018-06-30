class PagesController < ApplicationController
  before_action :redirect_if_signed_in!, only: [:index]

  PAGES = {
    "Terms and Conditions": :terms,
    "Privacy Policy": :privacy,
    "Code of Conduct": :code_of_conduct,
    "Frequently Asked Questions": :faqs,
    "Exercism's Values": :values,
    "About Exercism": :about,
    "Getting Started": :getting_started,
    "Become a Mentor": :become_a_mentor,
    "Become a Maintainer": :become_a_maintainer
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
    @tracks = Track.active.reorder(SQLSnippets.random).to_a
  end
end
