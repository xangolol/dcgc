# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery(document).on "page:change", ->
  jQuery(".dinner-label").tooltip()
  jQuery(".button_to button[type=submit]").click ->
    jQuery(this).parents(".button_to").submit()

