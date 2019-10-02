class PagesController < ApplicationController
  before_action :redirect_if_signed_in!, only: [:index]
  skip_before_action :ensure_onboarded!
  skip_before_action :store_location

  PAGES = {
    #"About Exercism": :about,

    "Terms of Service": :terms_of_service,
    "Privacy Policy": :privacy,
    "Code of Conduct": :code_of_conduct,
    "Frequently Asked Questions": :faqs,
    "Command Line Interface": :cli,
    "Exercism's Values": :values,
    "Getting Started": :getting_started,
    "Become a Maintainer": :become_a_maintainer,
    "Report Abuse": :report_abuse,
    "Contact": :contact,
    "Mentored Mode vs Practice Mode": :mentored_mode_vs_independent_mode,
    "How to Contribute": :contribute,

    "Roadmap": :roadmap,
    "Changelog": :changelog,

    "Mentoring Guide": :mentoring_guide,
    "Getting started with mentoring": :mentoring_getting_started,
    "Mentoring workflow": :mentoring_workflow,
    "Mentoring FAQs": :mentoring_faqs,

    "About the new site": :about_v1_to_v2,
    "Migrating to the new CLI": :cli_v1_to_v2,
  }

  HELP_PAGES = {
    "Automated solution analysis": :automated_solution_analysis,
    "How do mentor queues work?": :how_do_mentor_queues_work
  }

  LICENCES = {
    "MIT": :mit,
    "CC-BY-SA-4.0": :cc_sa_4
  }

  PAGE_GENERATOR = -> (pages, repo_location) do
    pages.each do |title, page|
      define_method page do
        markdown = Git::WebsiteContent.head.send(repo_location)["#{page}.md"] || ""
        @page = page
        @page_title = title
        @content = ParseMarkdown.(markdown.to_s)
        render action: "generic"
      end
    end
  end

  PAGE_GENERATOR.(PAGES, :pages)
  PAGE_GENERATOR.(LICENCES, :licences)
  PAGE_GENERATOR.(HELP_PAGES, :pages)

  # Landing page
  def index
    @tracks = Track.active.reorder(SQLSnippets.random).to_a
  end

  def cli_walkthrough
    @walkthrough = RenderUserWalkthrough.(
      current_user,
      Git::WebsiteContent.head.walkthrough
    )
  end

  def about
  end

  def strategy
    markdown = Git::WebsiteContent.head.pages["strategy.md"] || ""
    @content = ParseMarkdown.(markdown.to_s)
  end

  def supporter_mozilla
    @supporter_name = "Mozilla"
    @supporter_logo = "mozilla-white.png"
    @supporter_website_url = "https://foundation.mozilla.org"
    @supporter_blog_posts = BlogPost.where(id: [10,8])

    @supporter_support_details = ParseMarkdown.(%q{
      Mozilla supported us in the creation of our automated analyzers. They funded the product design, prototype, and analyzer infrastructure, saving thousands of hours of mentors time, and dramatically reducing wait-times for students.
    }.strip)

    @supporter_about = ParseMarkdown.(%q{
      Mozilla is a global non-profit dedicated to putting you in control of your online experience and shaping the future of the web for the public good.
    }.strip)

    render action: 'supporter'
  end

  def supporter_sloan
    @supporter_name = "The Sloan Foundation"
    @supporter_logo = "sloan-white.png"
    @supporter_website_url = "https://sloan.org"
    @supporter_blog_posts = BlogPost.where(id: [15])

    @supporter_support_details = ParseMarkdown.(%q{
The Sloan Fondation are supporting the design and development of new tracks on Exercism, in partnership with the University of Chicago. They are funding our research and prototyping, and allowing us to dramatically accelerate the creation of new educational pathways.
    }.strip)

    @supporter_about = ParseMarkdown.(%q{
The Sloan Foundation funds research and education in science, technology, engineering, mathematics and economics

Founded in 1934 by industrialist Alfred P. Sloan Jr., the Foundation is a not-for-profit grantmaking institution that supports high quality, impartial scientific research; fosters a robust, diverse scientific workforce; strengthens public understanding and engagement with science; and promotes the health of the institutions of scientific endeavor.
    }.strip)

    render action: 'supporter'
  end

  def supporter_thalamus
    @supporter_name = "Thalamus"
    @supporter_logo = "thalamus-white.png"
    @supporter_website_url = "https://thalamus.ai"
    @supporter_blog_posts = BlogPost.where(id: [1])

    @supporter_support_details = ParseMarkdown.(%q{
      Thalamus's team manage the website and operational sides of Exercism. Along with Katrina, they were responsible for the development of the new Exercism, helping research and design the new product, and creating the technology that powers the site.
    }.strip)

    @supporter_about = ParseMarkdown.(%q{
Thalamus is a team of software developers, data scientists and product experts, working with industry experts to create innovative solutions to big issues.

Their vision is to help build a better future for everyone by improving the quality of healthcare and education available to all.
    }.strip)

    render action: 'supporter'
  end
end
