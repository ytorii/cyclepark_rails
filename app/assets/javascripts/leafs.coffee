# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Scripts for the leaf's show page.
leafs_show = ->
  # Scrolling to the end of contract list.
  unless $('#contracts_list').size() is 0
    $('#contracts_list').scrollTop($('#contracts_list')[0].scrollHeight)
  # Changes parameters and input forms depending on the contract type.
  $('input[name="cont_type"]:radio').change ->
    switch $(@).val()
      when "1"
        $('#additionForm').css({'display':'block'})
        $('#term2').css({'display':'none'})
        $('#contract_skip_flag').val(false)
      when "2"
        $('#additionForm').css({'display':'block'})
        $('#term2').css({'display':'block'}) 
        $('#contract_skip_flag').val(false)
      when "3"
        $('#additionForm').css({'display':'none'})
        $('#contract_skip_flag').val(true) 
    $('#contadd_reset_btn').click()
    $('#contract_term1').focus()

# Scripts for the leaf's new and edit form.
leafs_form = ->
  # Student flag is needed only for 1st area contracts.
  # Lragebike flag is needed only for bike contracts.
  $('input[name="leaf[vhiecle_type]"]:radio').change ->
    switch $(@).val()
      when "1"
        $('#student_checkbox').css({'display':'block'})
        $('#largebike_checkbox').css({'display':'none'})
      when "2"
        $('#student_checkbox').css({'display':'none'})
        $('#largebike_checkbox').css({'display':'block'})
      when "3"
        $('#student_checkbox').css({'display':'none'})
        $('#largebike_checkbox').css({'display':'none'})

# On page load, this function will be called.
ready = ->
  leafs_show()
  leafs_form()

$(document).ready(ready)
# ready function for Turbolinks
$(document).on('page:load', ready)
