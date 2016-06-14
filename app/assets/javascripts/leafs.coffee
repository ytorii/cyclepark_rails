# Scripts for ajax function to get term's money
get_termsprice = (in_data) ->
  req = $.ajax({
    async: true
    url: "/termsprice"
    type: "POST"
    data: in_data
    dataType: 'json'
  })

  req.done (data, stat, xhr) ->
    $('#contract_money1').val(data.price)

  req.fail (xhr, stat, err) ->
    console.log({ fail: stat, error: err, xhr: xhr })

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

# Scripts for the contract addition submit button
contract_addition = ->
  # Submit is prohibited in all ajax actions!
  $(document).ajaxStart ->
    $('#contadd_submit_btn').val('処理中...').attr('disabled', 'true')
  .ajaxComplete ->
    $('#contadd_submit_btn').val('登録する').removeAttr('disabled')
  
  # Getting money for selected term with ajax.
  $('input[name="contract[term1]"]:radio').change (e) ->
    post_data = {
      term: $(@).val()
      leaf_id: $('#contract_leaf_id').val()
    }
    get_termsprice(post_data)

  # Close and reset value only when contract addition is done.
  $('#contadd_submit_btn').on 'click', (e) ->
    $('#new_contract').on('ajax:complete', (event, data, status) ->
      $('#contadd_reset_btn').click()
      $('#contadd_close_btn').click()
      $('#contracts_list').scrollTop($('#contracts_list')[0].scrollHeight)
      # Remove popup messages from server after 5 seconds.
      setTimeout ->
        $("#system_messages").fadeTo(500,0).slideUp ->
          $(this).remove()
      , 5000
    )

# On page load, this function will be called.
init = ->
  leafs_show()
  leafs_form()
  contract_addition()

$(document).ready(init)
# ready function for Turbolinks
$(document).on('page:load', init)
