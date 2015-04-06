#= require tag_generate.js
#= require options_builder.js

describe 'OptionsBuilder', ->
  optionsBuilder = null
  html = null

  describe 'from an array of objects with :value and :text keys', ->
    beforeEach ->
      optionsBuilder = new OptionsBuilder()
        .addOption(value: 1, text: 'One')
        .addOption(value: 2, text: 'Two')
        .addOption(value: 3, text: 'Three')
        .selectValue(3)
      html = optionsBuilder.toHTML()

    it 'should build options', ->
      expect($(html)).toBe('option[value=1]:contains(One)')
      expect($(html)).toBe('option[value=2]:contains(Two)')
      expect($(html)).toBe('option[value=3][selected]:contains(Three)')

  describe 'with an array of objects configured to pluck attributes', ->
    beforeEach ->
      optionsBuilder = new OptionsBuilder()
        .addOption(name: "Bob", id: 1)
        .addOption(name: "Bill", id: 2)
        .selectValue(2)
        .pluck(text: 'name', value: 'id')
      html = optionsBuilder.toHTML()

    it 'should generate options', ->
      expect($(html)).toBe('option[value=1]:contains(Bob)')
      expect($(html)).toBe('option[value=2][selected]:contains(Bill)')


  describe 'with an array of values configured for special extraction', ->
    beforeEach ->
      optionsBuilder = new OptionsBuilder()
        .addOptions([1, 2, 3])
        .selectValue(2)
        .extract(
          text: (age) -> "#{age} yo"
          value: (age) -> age
        )
      html = optionsBuilder.toHTML()

    it 'should build options', ->
      expect($(html)).toBe('option[value=1]:contains(1 yo)')
      expect($(html)).toBe('option[value=2][selected]:contains(2 yo)')
      expect($(html)).toBe('option[value=3]:contains(3 yo)')


  describe 'from separate alues & texts', ->
    beforeEach ->
      values = [1, 2, 3]
      texts = ['One', 'Two', 'Three']
      optionsBuilder = OptionsBuilder.fromValuesAndTexts(values, texts, 3)
      html = optionsBuilder.toHTML()

    it 'should build options', ->
      expect($(html)).toBe('option[value=1]:contains(One)')
      expect($(html)).toBe('option[value=2]:contains(Two)')
      expect($(html)).toBe('option[value=3][selected]:contains(Three)')


  describe 'with hash of key/values', ->
    beforeEach ->
      hashValues = {1: 'First', 2: 'Second', 4: 'Fourth'}
      optionsBuilder = OptionsBuilder.fromHash(hashValues)

    it 'should build options as HTML', ->
      html = $(optionsBuilder.toHTML())
      expect(html).toBe('option[value=1]:contains(First)')
      expect(html).toBe('option[value=2]:contains(Second)')
      expect(html).toBe('option[value=4]:contains(Fourth)')

    it 'should build options with a selected', ->
      optionsBuilder.selectValue(2)
      html = $(optionsBuilder.toHTML())
      expect(html).toBe('option[value=1]:contains(First)')
      expect(html).toBe('option[value=2][selected]:contains(Second)')
      expect(html).toBe('option[value=4]:contains(Fourth)')

    it 'should build options with a nil selected', ->
      optionsBuilder.selectValue(null)
      html = $(optionsBuilder.toHTML())
      expect(html).toBe('option[value=1]:contains(First)')
      expect(html).toBe('option[value=2]:contains(Second)')
      expect(html).toBe('option[value=4]:contains(Fourth)')
