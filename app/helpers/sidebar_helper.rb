module SidebarHelper
  ICONS = {
    "home"        => "fa-solid fa-house",
    "folder"      => "fa-solid fa-folder-open",
    "clipboard"   => "fa-solid fa-clipboard-list",
    "document"    => "fa-solid fa-file-lines",
    "exclamation" => "fa-solid fa-triangle-exclamation",
    "check"       => "fa-solid fa-circle-check",
    "shield"      => "fa-solid fa-shield-halved",
    "cube"        => "fa-solid fa-boxes-stacked",
    "users"       => "fa-solid fa-people-group",
    "currency"    => "fa-solid fa-won-sign",
    "receipt"     => "fa-solid fa-file-invoice",
    "paperclip"   => "fa-solid fa-paperclip",
    "building"    => "fa-solid fa-building"
  }.freeze

  def sidebar_link(label, path, icon_name)
    is_active = current_page?(path) || (path != root_path && request.path.start_with?(path.to_s.split("?").first))
    active_class = if is_active
      "bg-blue-50 text-blue-700"
    else
      "text-gray-600 hover:text-gray-900 hover:bg-gray-100"
    end

    icon_class = ICONS[icon_name] || "fa-solid fa-folder"

    content_tag(:li) do
      link_to path, class: "group flex items-center gap-x-2.5 rounded-md px-2 py-1.5 text-sm font-medium transition-colors #{active_class}" do
        content_tag(:i, "", class: "#{icon_class} w-4 text-center text-sm shrink-0", "aria-hidden": "true") +
        content_tag(:span, label)
      end
    end
  end
end
