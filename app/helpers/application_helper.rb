module ApplicationHelper
  
  def fa_submit(form, fa_class, options = {}, html_options = {})
    button_to({type: 'submit'}.merge(options), html_options) do
      fa_icon fa_class
    end
  end

end
