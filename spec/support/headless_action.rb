module HeadlessAction
  def fill_in_val(id, options)
    with = options.delete(:with)
    page.execute_script "document.getElementById(\"#{id}\").value = \"#{with}\";"
  end
end
