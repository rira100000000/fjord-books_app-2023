# frozen_string_literal: true

module ReportsHelper
  def add_a_tag(content)
    URI.extract(content, %w[http https]).uniq.each do |url|
      content.gsub!(url, "<a href='#{url}'>#{url}</a>")
    end
    content.gsub!("\n", '<br>')
    content
  end
end
