# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  if !(document.getElementById("submit_registration") is null)
    #calculate total on page load (incase of redirect)
    registration.update_total()
    registration_payment.amountUpdate()

  # Validate email address
  emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
  $('#registration_email').on 'keydown', ->
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
  $("#students").on "keydown", ->
    registration.update_total()

  #Update student count and total when field is removed
  $("#students").on "click", ->
    setTimeout (-> registration.update_total()), 1000

  # Count shirts selected if page is reloaded
  student.shirt_selected($('.fields'))

  # Set listener for created field
  $(document).on 'nested:fieldAdded', (event) ->
    student.shirt_selected(event.field)

  # Warn user if tuition waiver is selected with tshirt purchase
  $('#registration_fee_waiver').on 'change', ->
    alert student.shirt_count()
    if student.shirt_count() > 0
      alert 'You have elected to have the tuition waved for this registration, but have asked to purchase a shirt(s). If you continue with this registration and tuition is waived we will not be able to provide the requested t-shirt(s).'

  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  registration_payment.setupForm()

student =
  shirt_selected: (student_fields) ->
    student_fields.find('input.boolean').on 'change', ->
      select = $(this).closest('td').next().find('select')
      if $(this).is(':checked')
        select.prop('disabled', false)
      else
        select.val(select.find('option:first').val()).prop('disabled', true)

  shirt_count: ->
    count = 0
    $("[id$='_shirt']:checkbox:checked", '#students').each ->
      count += 1
    count

  count: ->
    count = 0
    $("#students").find("[id$='_first_name']").each ->
      if ($(this).val() or $(this).closest("[id$='_last_name']").val()) and $(this).closest('tr').is(":visible")
        count += 1
    count

registration =
  update_total: ->
    student_count = student.count()
    shirt_count = student.shirt_count()

    $("#registration_student_count").val(student_count)
    $('#total > p').children('span').text("$#{(student_count * 10) + (shirt_count * 15)}.00")
    registration_payment.amountUpdate()

registration_payment =
  setupForm: ->
    $('#new_registration').submit ->
      registration.update_total()
      if student.count() == 0
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
