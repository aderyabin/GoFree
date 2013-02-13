_           = require "underscore"
async       = require "async"
moment      = require "moment"
request     = require "request"

exports.name = "airbnb"

exports.search = (origin, destination, extra, cb) ->

    operations = _.map [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], (i) ->

        return (cb) ->

            airUrl = "https://m.airbnb.com/api/v1/listings/search?checkin=#{origin.date}&checkout=#{destination.date}&location=#{destination.place.country_name_ru}--#{destination.place.name_ru}&number_of_guests=#{extra.adults}&offset=#{i*20}"

            (error, response, body) <- request airUrl
            console.log "AIRBNB: Queried serp | #{airUrl} | status #{response.statusCode}"
            return cb(error, null) if error

            json = JSON.parse(response.body)
            return cb({message: 'no listings'}, null) if not json.listings

            results = _.map json.listings, (r) ->
                
                listing = r.listing

                days = moment.duration(moment(destination.date) - moment(origin.date)).days()

                return {
                  name      : listing.name
                  stars     : null
                  price     : listing.price * 30 * days
                  rating    : null
                  photo     : listing.medium_url
                  provider  : \airbnb
                  id        : r.id
                }

            cb null, results


    async.parallel operations, (error, results) ->

        cb null, {
            results : _.flatten(results),
            complete: true
        }