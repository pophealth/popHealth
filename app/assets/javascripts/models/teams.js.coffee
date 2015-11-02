class Thorax.Models.Team extends Thorax.Model
  urlRoot: '/api/teams'
  idAttribute: '_id' 

class Thorax.Collections.Teams extends Thorax.Collection
  url: '/api/teams'
  model: Thorax.Models.Team
