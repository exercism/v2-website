class PagesController < ApplicationController
  before_action :redirect_if_signed_in!, only: [:index]

  PAGES = %w{
    donate
    terms privacy
    faqs about
    bootcamps
    become_a_mentor become_a_maintainer
  }

  PAGES.each do |page|
    define_method page do
      # TODOGIT Read from
      # https://github.com/exercism/website_copy
      # pages/#{page}.md
      markdown = ""

      @content = ParsesMarkdown.parse(markdown.to_s)
    end
  end
end
