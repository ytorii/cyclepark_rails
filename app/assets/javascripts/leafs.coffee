# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('#contracts_list').scrollTop($('#contracts_list')[0].scrollHeight)
  $('input[name="cont_type"]:radio').change ->
    $('#contadd_reset_btn').click()
    switch $(@).val()
      when "1"
        $('#additionForm').css({'display':'block'})
        $('#contract_skip_flag').val(false)
        $('#term2').css({'display':'none'})
      when "2"
        $('#additionForm').css({'display':'block'})
        $('#contract_skip_flag').val(false)
        $('#term2').css({'display':'block'}) 
      when "3"
        $('#additionForm').css({'display':'none'})
        $('#contract_skip_flag').val(true) 
    $('#contract_term1').focus()

$(document).ready(ready)
# ready function for Turbolinks
$(document).on('page:load', ready)
