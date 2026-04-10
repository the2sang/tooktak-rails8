module ApplicationHelper
  def page_header(title, &block)
    content_for(:title) { title }
    content_tag(:div, class: "mb-6 flex items-center justify-between") do
      content_tag(:h1, title, class: "text-2xl font-bold text-gray-900") +
      (block ? capture(&block) : "".html_safe)
    end
  end

  def badge(text, color = :gray)
    colors = {
      gray: "bg-gray-100 text-gray-800",
      blue: "bg-blue-100 text-blue-800",
      green: "bg-green-100 text-green-800",
      yellow: "bg-yellow-100 text-yellow-800",
      red: "bg-red-100 text-red-800",
      orange: "bg-orange-100 text-orange-800",
      indigo: "bg-indigo-100 text-indigo-800"
    }
    content_tag(:span, text, class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium #{colors[color]}")
  end

  def status_badge(value)
    color = case value.to_s
            when "completed", "passed", "paid", "resolved", "closed", "active" then :green
            when "in_progress", "status_in_progress", "ordered", "delivered" then :blue
            when "pending", "draft", "planned", "scheduled", "open", "not_started" then :yellow
            when "cancelled", "rejected", "failed", "suspended", "overdue" then :red
            when "on_hold", "delayed", "conditionally_passed" then :orange
            else :gray
            end
    badge(KoreanEnum::TRANSLATIONS[value.to_s] || value.to_s.humanize, color)
  end

  def severity_badge(value)
    color = case value.to_s
            when "critical" then :red
            when "major" then :orange
            when "minor" then :yellow
            when "trivial" then :gray
            else :gray
            end
    badge(KoreanEnum::TRANSLATIONS[value.to_s] || value.to_s, color)
  end

  def priority_badge(value)
    color = case value.to_s
            when "urgent" then :red
            when "high" then :orange
            when "medium" then :blue
            when "low" then :gray
            else :gray
            end
    badge(KoreanEnum::TRANSLATIONS[value.to_s] || value.to_s, color)
  end

  def format_amount(amount)
    return "-" if amount.blank?
    number_to_currency(amount, unit: "", delimiter: ",", precision: 0) + "원"
  end

  def format_date(date)
    return "-" if date.blank?
    date.strftime("%Y-%m-%d")
  end

  def btn_primary(text, path, **options)
    link_to text, path, class: "inline-flex items-center rounded-md bg-blue-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-blue-500 #{options.delete(:class)}", **options
  end

  def btn_secondary(text, path, **options)
    link_to text, path, class: "inline-flex items-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 #{options.delete(:class)}", **options
  end
end
