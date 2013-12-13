describe 'User', ->
  beforeEach ->
    json = loadJSONFixtures('categories.json', 'users.json')
    @categories = new Thorax.Collections.Categories json['categories.json'], parse: true
    @user = new Thorax.Models.User $.extend(true, {}, json['users.json'][0])
    expect(@user.get('preferences').selected_measure_ids).toEqual []

  describe 'maskStatus', ->
    it 'returns false if the user has not enabled masking under settings', ->
      maskStatus = @user.maskStatus()
      expect(maskStatus).toEqual false

  describe 'selectedCategories', ->
    it 'returns an empty collection if there are no selected categories', ->
      selectedCategories = @user.selectedCategories(@categories)
      expect(selectedCategories).toBeEmpty()

    it 'returns a populated collection if there are selected categories', ->
      @user.get('preferences').selected_measure_ids = [@categories.first().get('measures').first().id]
      selectedCategories = @user.selectedCategories(@categories)
      expect(selectedCategories.length).toEqual 1
      expect(selectedCategories.first().get('category')).toEqual @categories.first().get('category')
      expect(selectedCategories.first().get('measures').first()).toBe @categories.first().get('measures').first()

    it 'can add a new selected measure to an existing selected category', ->
      @user.get('preferences').selected_measure_ids = [(firstMeasure = @categories.first().get('measures').first()).id]
      selectedCategories = @user.selectedCategories(@categories)
      spyOn @user, 'save'
      newSelection = @categories.first().get('measures').at(1)
      selectedCategories.selectMeasure newSelection
      expect(@user.save).toHaveBeenCalled()
      expect(@user.get('preferences').selected_measure_ids).toEqual [firstMeasure.id, newSelection.id]

    it 'can remove a selected measure from an existing category', ->
      @user.get('preferences').selected_measure_ids = [(firstMeasure = @categories.first().get('measures').first()).id]
      selectedCategories = @user.selectedCategories(@categories)
      spyOn @user, 'save'
      selectedCategories.removeMeasure selectedCategories.first().get('measures').first()
      expect(@user.save).toHaveBeenCalled()
      expect(@user.get('preferences').selected_measure_ids).toEqual []

    it 'adds a new category when adding a measure to a category not yet selected', ->
      newSelection = @categories.first().get('measures').first()
      selectedCategories = @user.selectedCategories(@categories)
      spyOn @user, 'save'
      selectedCategories.selectMeasure newSelection
      expect(selectedCategories.first().get('category')).toEqual @categories.first().get('category')
      expect(selectedCategories.first().get('measures').first()).toBe newSelection

    it 'removes empty categories when removing the last measure in a category', ->
      @user.get('preferences').selected_measure_ids = [(firstMeasure = @categories.first().get('measures').first()).id]
      selectedCategories = @user.selectedCategories(@categories)
      spyOn @user, 'save'
      selectedCategories.removeMeasure selectedCategories.first().get('measures').first()
      expect(@user.save).toHaveBeenCalled()
      expect(selectedCategories).toBeEmpty()

    describe 'when selecting a category', ->
      beforeEach ->
        @firstCat = @categories.first()
        @secondCat = @categories.at(1)
        @selectedCategories = @user.selectedCategories(@categories)
        spyOn @user, 'save'
        @selectedCategories.selectCategory @firstCat
        expect(@user.save).toHaveBeenCalled()

      it 'adds all measure ids of the category', ->
        expect(@user.get('preferences').selected_measure_ids).toEqual @firstCat.get('measures').pluck('id')
        @selectedCategories.selectCategory @secondCat
        expect(@user.save).toHaveBeenCalled()
        expect(@user.get('preferences').selected_measure_ids).toEqual @firstCat.get('measures').pluck('id').concat(@secondCat.get('measures').pluck('id'))

      it 'adds the new category to the selected categories', ->
        expect(@selectedCategories.length).toEqual 1
        @selectedCategories.selectCategory @secondCat
        expect(@user.save).toHaveBeenCalled()
        expect(@selectedCategories.length).toEqual 2

    describe 'when removing a category', ->
      beforeEach ->
        @firstCat = @categories.first()
        @secondCat = @categories.at(1)
        @user.get('preferences').selected_measure_ids = @firstCat.get('measures').pluck('id').concat(@secondCat.get('measures').pluck('id'))
        @selectedCategories = @user.selectedCategories(@categories)
        spyOn @user, 'save'
        @selectedCategories.removeCategory @firstCat
        expect(@user.save).toHaveBeenCalled()

      it 'removes all measures ids of the category', ->
        expect(@user.get('preferences').selected_measure_ids).toEqual @secondCat.get('measures').pluck('id')
        @selectedCategories.removeCategory @secondCat
        expect(@user.save).toHaveBeenCalled()
        expect(@user.get('preferences').selected_measure_ids).toEqual []

      it 'removes the category from the selected categories', ->
        expect(@selectedCategories.length).toEqual 1
        @selectedCategories.removeCategory @secondCat
        expect(@user.save).toHaveBeenCalled()
        expect(@selectedCategories).toBeEmpty()
