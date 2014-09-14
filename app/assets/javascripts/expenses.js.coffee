# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
(($) ->
  $.fn.calculator = ->
    modal = this
    answer = modal.find("input#expense_amount")
    label = modal.find("label[for=expense_amount]")

    #add value field to be cloned
    answer.parent().before '<div class="input-holder hide original"><input class="calculator" type="number" /></div>'
    original = modal.find(".original")

    modal.on 'keypress', '#expense_amount', (e) ->
      if e.charCode is 43 or e.charCode is 45
        e.preventDefault()
        clone = original.clone().removeClass("hide original").addClass('clone')
        label.after clone
        clone.children('.calculator').val(answer.val())
        if e.charCode is 43
          clone.prepend('+')
          clone.children('.calculator').addClass('add')
        if e.charCode is 45
          clone.prepend('-')
          clone.children('.calculator').addClass('subtract')
        modal.off 'keypress', '#expense_amount'

    modal.on 'keypress', ".calculator", (e) ->
      if e.charCode is 43 or e.charCode is 45
        e.preventDefault()
        clone = original.clone().removeClass("hide original").addClass('clone')
        answer.parents(".input-holder").before clone
        clone.children('.calculator').focus().select()
        if e.charCode is 43
          clone.prepend('+')
          clone.children('.calculator').addClass('add')
        if e.charCode is 45
          clone.prepend('-')
          clone.children('.calculator').addClass('subtract')

    modal.on 'blur', '.clone .calculator', (e) ->
      add = 0
      subtract = 0

      if !$(this).val()
        $(this).val(0)

      modal.find(".clone .calculator.add").each ->
        add += parseFloat($(this).val(), 10)

      modal.find(".clone .calculator.subtract").each ->
        subtract += parseFloat($(this).val(), 10)

      answer.val((add - subtract).toFixed(2))
) jQuery

jQuery(document).ready ->
  jQuery("#modal").on 'shown', (e) ->
    jQuery("#modal").calculator()
