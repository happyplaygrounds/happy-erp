# app/inputs/percent.rb
class PercentInput < SimpleForm::Inputs::Base
def input(wrapper_options)
    percent = options.delete(:percent) || default_percent
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    content_tag(:div, input_group(percent, merged_input_options), class: "input-group")
  end

  private

  def input_group(percent, merged_input_options)
    "#{@builder.text_field(attribute_name, merged_input_options)} #{percent_addon(percent)}".html_safe
  end

  def percent_addon(percent)
     content_tag(:h4, percent, class: "input-group-addon")
  end

  def default_percent
    "%"
  end

end
