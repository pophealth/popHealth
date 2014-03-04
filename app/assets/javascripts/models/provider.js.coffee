class Thorax.Models.Provider extends Thorax.Model
  urlRoot: '/api/providers'
  idAttribute: '_id'
  providerType: -> @get("cda_identifiers")?[0].root
  providerExtension: -> @get("cda_identifiers")?[0].extension

class Thorax.Collections.Providers extends Thorax.Collection
  url: '/api/providers'
  model: Thorax.Models.Provider