module HeadlessAction
  def fill_in_val(id, options)
    with = options.delete(:with)
    page.execute_script "document.getElementById(\"#{id}\").value = \"#{with}\";"
  end

  def clicklink_by_text_script(text)
    script = %Q{$("a:contains('} + text + %Q{')").click()}
    page.evaluate_script(script)
  end
end
