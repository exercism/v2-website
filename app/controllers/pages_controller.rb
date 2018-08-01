class PagesController < ApplicationController
  before_action :redirect_if_signed_in!, only: [:index]

  PAGES = {
    "Terms of Service": :terms_of_service,
    "Privacy Policy": :privacy,
    "Code of Conduct": :code_of_conduct,
    "Frequently Asked Questions": :faqs,
    "Command Line Interface": :cli,
    "Exercism's Values": :values,
    "About Exercism": :about,
    "Getting Started": :getting_started,
    "Become a Mentor": :become_a_mentor,
    "Become a Maintainer": :become_a_maintainer,
    "Report Abuse": :report_abuse,
    "Contact": :contact,
    "Contribute": :contribute,
    "Mentored Mode vs Independent Mode": :mentored_mode_vs_independent_mode,

    "Mentoring Guide": :mentoring_guide,
    "Mentoring FAQs": :mentoring_faqs,

    "About the new site": :about_v1_to_v2,
    "Migrating to the new CLI": :cli_v1_to_v2,
  }

  LICENCES = {
    "MIT": :mit,
    "CC-BY-SA-4.0": :cc_sa_4
  }

  PAGES.merge(LICENCES).each do |title, page|
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
    @tracks = Track.active.reorder(SQLSnippets.random).to_a
  end

  def cli_walkthrough
    @walkthrough = RendersUserWalkthrough.(
      current_user,
      Git::WebsiteContent.head.walkthrough
    )
  end
end
