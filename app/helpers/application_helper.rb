module ApplicationHelper
  def fa_button_to(fa_class, options = nil, html_options = nil)
    button_to(options, html_options) do
      fa_icon fa_class
    end
  end
end
