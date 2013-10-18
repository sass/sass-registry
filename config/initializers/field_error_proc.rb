# Set the default field error proc
ActionView::Base.field_error_proc = Proc.new do |html, instance|
  if html !~ /label/
    %{<span class="error_with_field">#{html} <span class="error">&bull; #{[instance.error_message].flatten.first}</span></span>}.html_safe
  else
    html
  end
end
