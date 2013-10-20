#let the modal button submit the actual form
jQuery(document).ready ->
	jQuery(".button_to [type=submit]").click ->
    jQuery(this).parents(".button_to").submit()