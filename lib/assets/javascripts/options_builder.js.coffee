# = OptionsBuilder
#
# This builder can generate a list of option HTML elements using jQuery $('<option/>').
# Use addOption() or addOptions() to add objects in the order in which you want them to appear
# as option tags.
#
# Example:
#    optionBuilder = new OptionsBuilder
#      .addOption(text: 'text0', value: 'value0')
#      .addOptions([{text: 'text1', value: 'value1'}, {text: 'text2', value: 'value2'}])
#      .selectValue('value2')
#
# When you have configured the builder to your liking, call .toJQuery() to retrieve the list of option tags.
# The built option tags can be used to set a select boxes options directly:
#
# Example:
#    $('select.mySelectBox').html(optionBuilder.toJQuery())
#
#
# = Value and Text for each option
#
# By convention the builder assumes each option has 'text' and 'value' keys, and will use these
# for the corresponding option attributes:
#    <option value="valueX">textX</option>
#
# For customisation, you can pluck different attributes:
#    new OptionsBuilder
#      .addOptions([{name: 'text1', id: 'value1'}, {name: 'text2', id: 'value2'}])
#      .pluck(text: 'name', value: 'id')
#      .toJQuery()
#
# ...or if you want to run a function to determine text or value, use getText/getValue:
#    new OptionsBuilder
#      .addOptions([{age: 1}, {age: 21}, {age: 65}])
#      .extract(text: (option) -> "#{option.age} Years Old")
#      .extract(value: ((option) -> option.age)
#
# Of course the options can be anything when you use these functions:
#    new OptionsBuilder
#      .addOptions([1, 21, 65])
#      .extract
#        text: (option) -> "#{option} Years Old"
#        value: _.identity      # identity is same as: (option) -> option
#
# In addition, there are a number of helper methods on the class
# OptionsBuilder itself -- these allow quick-setup of certain common
# cases:
# 
#   OptionsBuilder.fromHash({1: 'One', 2: 'Two'})
#   OptionsBuilder.fromValuesAndTexts([1,2], ['One', 'Two'], 2)

$ = jQuery

class window.OptionsBuilder
  constructor: ->
    @options = []
    @extractions = {}

    # Defaults
    @pluck(text: 'text', value: 'value')
    @selectedValue = null

  addOption: (option) ->
    @options.push(option)
    @

  addOptions: (options) ->
    @options = @options.concat(options)
    @

  selectValue: (selectedValue) ->
    @selectedValue = selectedValue
    @

  extract: (extractions) ->
    for own optionAttrName, lambda of extractions
      @extractions[optionAttrName] = lambda
    @

  # Accepts 'text' and 'value' keys with values specifying an attribute 
  # to use from the model option objects
  pluck: (fields) ->
    if fields.text?
      @extractions.text = (option) -> option[fields.text]
    if fields.value?
      @extractions.value = (option) -> option[fields.value]
    @

  build: ->
    for option in @options
      TagGenerate.option(
        @extractions.value(option), 
        @extractions.text(option), 
        @selectedValue
      )

  toJQuery: ->
    $options = $()
    for $option in @build()
      $options = $options.add($option)
    $options 

  toHTML: ->
    $('<div>').append(@toJQuery()).html()


# Creates an optionsBuilder instance with 
# value from the key, text from the values
OptionsBuilder.fromHash = (optionsHash) ->
  optionsBuilder = new OptionsBuilder()
  for own value, text of optionsHash
    optionsBuilder.addOption(text: text, value: value)
  optionsBuilder


# Add options from two separate arrays of the same length
OptionsBuilder.fromValuesAndTexts = (values, texts, selected='') ->
  optionsBuilder = new OptionsBuilder()
  if values.length != texts.length
    throw "Values and text arrays must match in lenght" 

  optionsBuilder.selectValue(selected)
  for i in [0..(values.length - 1)]
    optionsBuilder.addOption(value: values[i], text: texts[i])
  optionsBuilder
  
