module BreadcrumbHelper
  def breadcrumb_nav(&block)
    content_tag :nav, content_tag(:ol, class: 'lo-container', &block), 'aria-label': 'Breadcrumb', class: 'breadcrumb'
  end

  def current_link(link_text)
    link_to link_text, request.path, 'aria-current': :page, class: 'current-link'
  end
end
