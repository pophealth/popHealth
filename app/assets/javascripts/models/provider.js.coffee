class Thorax.Models.Provider extends Thorax.Model
  urlRoot: '/api/providers'
  idAttribute: '_id'

class Thorax.Collections.Providers extends Thorax.Collection
  url: '/api/providers'
  model: Thorax.Models.Provider