# Generate HTML Tags... with nice semantics

$ = jQuery

window.TagGenerate =
  option: (value, name, selectedValue = null) ->
    isSelected = -> selectedValue? && value.toString() == selectedValue.toString()

    optionAttrs = {value: value}
    optionAttrs['selected'] = 'selected' if isSelected()
    $('<option/>', optionAttrs).text(name)


