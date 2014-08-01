class Thorax.Models.Provider extends Thorax.Model
  urlRoot: '/api/providers'
  idAttribute: '_id'
  providerType: -> @get("cda_identifiers")?[0].root
  providerExtension: -> @get("cda_identifiers")?[0].extension
  parse: (attrs) ->
    attrs = $.extend true, {}, attrs
    attrs.children = new Thorax.Collections.Providers attrs.children, parse: true if attrs.children?
    attrs
  toJSON: ->
    json = super
    json.children = json.children.toJSON() if json.children?
    json



class Thorax.Collections.Providers extends Thorax.Collection
  url: '/api/providers'
  model: Thorax.Models.Provider
  comparator: (p) ->
    parseInt(p.get('cda_identifiers')?[0].extension) || p.get('cda_identifiers')?[0].extension 
  initialize: (attrs, options) ->
    @hasMoreResults = true
  currentPage: (perPage = 100) -> Math.ceil(@length / perPage)
  fetch: ->
    result = super
    result.done => @hasMoreResults = /rel="next"/.test(result.getResponseHeader('Link'))
  fetchNextPage: (options = {perPage: 10}) ->
    data = {page: @currentPage(options.perPage) + 1, per_page: options.perPage}
    @fetch(remove: false, data: data) if @hasMoreResults
