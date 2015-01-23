describe 'Provider Index', ->
  beforeEach ->
    json = loadJSONFixtures 'users.json', 'providers.json'
    window.PopHealth.currentUser = new Thorax.Models.User $.extend(true, {}, json['users.json'][0])
    @provider1 = new Thorax.Models.Provider $.extend(true, {}, json['providers.json'][0])
    @provider2 = new Thorax.Models.Provider $.extend(true, {}, json['providers.json'][0])
    @providerId = json['providers.json'][0]._id
    @providerCollection = new Thorax.Collection [@provider1,@provider2], model: Thorax.Models.Provider
    
    @providerView = new Thorax.Views.ProvidersIndex collection: @providerCollection
    @providerView.render()

  it 'shows all providers', ->
    expect(@providerView.$el).toContainText @provider1.get 'given_name'
    expect(@providerView.$el).toContainText @provider2.get 'given_name'
