models = {}
collections = {}
views = {}

Router = Backbone.Router.extend
  _historyLimit: 10
  history: []

  routes:
    '':                          'index'
    'search/:hash':              'search'
    'journey/:hash':             'journey'

  initialize: ->
    @on('route', @_manageHistory)

    app.log('[app.Router]: initialize')

  _manageHistory: (rule, params...) ->
    # if (rule.indexOf('route') > - 1)

    @history.unshift(window.location.href)

    if @history.length > @_historyLimit
      @history.length = @_historyLimit

  index: ->
    app.log('[app.Router]: match "index"')

    unless views['index']
      models['search'] = new app.models.Search(trips: new app.collections.SearchTrips()) unless models['search']

      views['index'] = new app.views.Index(
        model: models['search']
      )

  search: (hash) ->
    app.log('[app.Router]: match "search", hash: "' + hash + '"')

    models['search'] = new app.models.Search(trips: new app.collections.SearchTrips())

    if views['serp']
      views['serp'].setup(
        hash: hash
        search: models['search']
        collection: new app.collections.SERPTrips()
        selected: new app.collections.SERPTripsSelected()
        )
    else       
      views['serp'] = new app.views.SERP(
        hash: hash
        search: models['search']
        collection: new app.collections.SERPTrips()
        selected: new app.collections.SERPTripsSelected()
      )

  journey: (hash)->
    app.log('[app.Router]: match "journey", hash: "' + hash + '"')

    views['journey'] = new app.views.Journey(
      hash: hash
      collection: new app.collections.Journey()
    )


app.Router = Router
