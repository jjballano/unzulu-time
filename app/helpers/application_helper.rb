module ApplicationHelper
  
  def fa_submit(fa_class, options = {}, html_options = {})    
    button_to({type: 'submit'}.merge(options), html_options) do
      fa_icon fa_class      
    end
  end

  def fa_button(fa_class, options = {}, html_options = {})    
    button_to(options, html_options) do
      fa_icon fa_class      
    end
  end

  def fa_link(fa_class, options = {}, html_options = {})    
    link_to(options, html_options) do
      fa_icon fa_class      
    end
  end

end
