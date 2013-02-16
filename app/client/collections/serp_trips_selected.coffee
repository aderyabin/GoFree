SERPTripsSelected = Backbone.Collection.extend
  _searchHash: null
  _observing: false
  _tripHash: null

  model: app.models.SERPTripSelected

  initialize: () ->
    @on('add', @instantiateCollections, @)

    app.log('[app.collections.SERPTripsSelected]: initialize')

  observe: ->
    @_observing = true
    app.socket.on('search_started', _.bind(@fetched, @))

  setHash: (@_searchHash) -> @

  fetched: (resp)->
    return unless resp.form.hash == @_searchHash

    data = resp.trips
    @add(resp.trips)

    @trigger('fetched', data)
    app.log('[app.collections.SERPTripsSelected]: fetched', data)

  instantiateCollections: (model) ->
    if @_observing
      model.observe()

  serialize: ->
    @toJSON()

  save: ->
    data = @serialize()
    @_tripHash = data['hash'] = md5(JSON.stringify(data))

    app.socket.emit('serp_selected', data)
    @trigger('save', data)

    app.log('[app.models.SERPTripSelected]: save', data)
    @_tripHash

app.collections.SERPTripsSelected = SERPTripsSelected
