class Thorax.Models.Provider extends Thorax.Model
  urlRoot: '/api/providers'
  idAttribute: '_id'
  providerType: -> @get("cda_identifiers")?[0].root
  providerExtension: -> @get("cda_identifiers")?[0].extension

class Thorax.Collections.Providers extends Thorax.Collection
  url: '/api/providers'
  model: Thorax.Models.Provider
  initialize: (attrs, options) ->
    @page = 1
  fetchNextPage: (options = {perPage: 10}) ->
    data = {page: ++@page, per_page: options.PerPage}
    @fetch remove: false, data:data
