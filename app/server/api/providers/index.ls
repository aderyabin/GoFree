eviterra 	= require "./eviterra"
ostrovok 	= require "./ostrovok"

exports.hotelProviders 	= [ostrovok]
exports.flightProviders = [eviterra]
exports.allProviders	= exports.hotelProviders + exports.flightProviders