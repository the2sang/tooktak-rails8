module ApplicationHelper
  def page_header(title, &block)
    content_for(:title) { title }
    content_tag(:div, class: "mb-6 flex items-center justify-between") do
      content_tag(:h1, title, class: "text-xl font-semibold text-gray-900 tracking-tight") +
      (block ? capture(&block) : "".html_safe)
    end
  end

  def badge(text, color = :gray)
    colors = {
      gray: "bg-gray-100 text-gray-600 border border-gray-200",
      blue: "bg-blue-50 text-blue-700 border border-blue-200",
      green: "bg-emerald-50 text-emerald-700 border border-emerald-200",
      yellow: "bg-amber-50 text-amber-700 border border-amber-200",
      red: "bg-red-50 text-red-700 border border-red-200",
      orange: "bg-orange-50 text-orange-700 border border-orange-200",
      indigo: "bg-indigo-50 text-indigo-700 border border-indigo-200"
    }
    content_tag(:span, text, class: "inline-flex items-center px-2 py-0.5 rounded-md text-xs font-medium #{colors[color]}")
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
    link_to text, path, class: "inline-flex items-center gap-1.5 rounded-lg bg-gray-900 px-3 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-gray-700 transition-colors #{options.delete(:class)}", **options
  end

  def btn_secondary(text, path, **options)
    link_to text, path, class: "inline-flex items-center gap-1.5 rounded-lg border border-gray-300 bg-white px-3 py-1.5 text-sm font-medium text-gray-700 hover:bg-gray-50 hover:border-gray-400 transition-colors #{options.delete(:class)}", **options
  end
end
