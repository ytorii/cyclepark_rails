module JavascriptMacros
  # As the money set by ajax is not reflected to the DOM tree,
  # get the money value by javascript.
  def getvalue_script(attribute)
    page.evaluate_script("$('#{attribute}').val()")
  end
end
