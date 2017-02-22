# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  if !(document.getElementById("submit_registration") is null)
    #calculate total on page load (incase of redirect)
    student_count.update()
    registration_payment.amountUpdate()

  # Validate email address
  emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
  $('#registration_email').on 'keydown', ->
    console.log $(this).val()
    if $(this).val() == ''
      $(this).parent().removeClass('has-success').addClass('has-danger')
    else if emailReg.test($(this).val())
      $(this).parent().removeClass('has-danger').addClass('has-success')
    else
      $(this).parent().removeClass('has-success').addClass('has-danger')

  # Add datables to all tables
  $('.datatable').DataTable
    pagingType: 'simple'


  # Update student count and total when text is enetered in fields
  $("#students").on "change", ->
    student_count.update()

  #Update student count and total when field is removed
  $("#students").on "click", "a", ->
    setTimeout (-> student_count.update()), 1000


  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  registration_payment.setupForm()

student_count =
  update: ->
    count = student_count.value()

    $("#registration_student_count").val(count)
    $('#total > p').children('span').text("$#{count * 10}.00")
    registration_payment.amountUpdate()

  value: ->
    count = 0
    $("#students").find("[id$='_first_name']").each ->
      if ($(this).val() or $(this).closest("[id$='_last_name']").val()) and $(this).closest('tr').is(":visible")
        count += 1
    count

registration_payment =
  setupForm: ->
    $('#new_registration').submit ->
      student_count.update()
      if student_count.value() == 0
        $('#stripe_error').text('Please add students to this registration.')
        false
      else
        if $('#registration_fee_waiver').is(":checked")
          registration_payment.amountUpdate()
          true
        else
          $('input[type=submit]').attr('disabled', true)
          if $('#card_number').val()
            registration_payment.processCard()
            false
          else if not $('#card_number').val() and $('#registration_stripe_card_token').val()
            true
          else
            alert "You have not entered a credit card."
            $('input[type=submit]').attr('disabled', false)
            false

  amountUpdate: ->
    str = $('#total > p').children('span').text()
    str = str.replace(",","").replace("$","").replace(".","")
    amount = parseInt(str)
    $('#registration_total').val(amount)

  processCard: ->
    card =
      name: $('#registration_email').val()
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, registration_payment.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
      registration_payment.amountUpdate()
      $('#registration_stripe_card_token').val(response.id)
      if confirm('Your information has been validated. Click OK to complete the transaction (this will bill your card).')
        $('#new_registration')[0].submit()
      else
        false
        $('input[type=submit]').attr('disabled', false)
    else
      $('#stripe_error').text(response.error.message)
      $('#cc_field').addClass('has-error')
      $('input[type=submit]').attr('disabled', false)
