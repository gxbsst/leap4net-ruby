module ApplicationHelper
  def locale_param
     %Q[<input type='hidden' name='locale', value="#{params[:locale] || I18n.default_locale}" />]
  end
end
