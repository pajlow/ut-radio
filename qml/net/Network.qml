pragma Singleton

import QtQuick 2.0
import Qt.labs.settings 1.0

import "../util"

Item {
   property string baseUrl

   function init(cb) {
      var request = new XMLHttpRequest()

      request.open('GET', 'https://fr1.api.radio-browser.info/json/servers', true);
      request.setRequestHeader("User-Agent", "UbuntuTouch-Radio-App")

      request.onload = function() {
         if (request.status >= 200 && request.status < 300) {
            var items

            try {
               items = JSON.parse(request.responseText).map(function(x) { return "https://" + x.name });
               baseUrl = items[Math.floor(Math.random() * items.length)];
            } catch (e) {
               return cb(i18n.tr("Failed to determine base host") + " (" + e + ")")
            }

            cb(null);
         } else {
            return cb(i18n.tr("Failed to determine base host") + " (" + request.statusText + ")")
         }
      }

      request.send();
   }

   function searchStation(searchTerm, category, sortByName, resultListReversed, cb) {
      if (!baseUrl)
         return cb(i18n.tr("Base URL unavailable"))

      var sortBy = sortNameToId(sortByName)

      var request = new XMLHttpRequest()
      var url = baseUrl + "/json/stations/" + categoryNameToId(category) + "/" + encodeURIComponent(searchTerm)

      url += "?order=" + sortBy + "&reverse=" + resultListReversed

      console.log(url)

      request.open('GET', url, true);
      request.setRequestHeader("User-Agent", "UbuntuTouch-Radio-App")

      request.onload = function() {
         if (request.status >= 200 && request.status < 300) {
            var stations

            try {
               stations = JSON.parse(request.responseText).map(function(x) {
                  return {
                     stationID: x.stationuuid,
                     name: x.name,
                     url: x.url_resolved,
                     image: x.favicon,
                     countryCode: x.countrycode,
                     favourite: Functions.hasFavourite(x.stationuuid),
                     language: x.language,
                     votes: x.votes,
                     clickcount: x.clickcount
                  }
               });
            } catch (e) {
               return cb(i18n.tr("Failed to parse search results") + " (" + e + ")")
            }

            cb(null, stations);
         } else {
            return cb(i18n.tr("Failed to determine base host") + " (" + request.statusText + ")")
         }
      }

      request.send();
   }

   function countClick(station) {
      if (!baseUrl)
         return

      var request = new XMLHttpRequest()

      request.open('GET', baseUrl + "/json/url/" + encodeURIComponent(station.stationID), true);
      request.setRequestHeader("User-Agent", "UbuntuTouch-Radio-App")

      request.onload = function() {
         if (request.status >= 200 && request.status < 300) {
         } else {
            return cb(i18n.tr("Failed to determine base host") + " (" + request.statusText + ")")
         }
      }

      request.send()
   }

   function categoryNameToId(name) {
      switch (name) {
      case i18n.tr("Language"): return "bylanguage"
      case i18n.tr("Tag"):      return "bytag"
      case i18n.tr("Country"):  return "bycountry"
      case i18n.tr("Name"):     break
      }

      return "byname"
   }

   function sortNameToId(name) {
      switch (name) {
      case i18n.tr("Tags"):        return "tags"
      case i18n.tr("Country"):     return "country"
      case i18n.tr("Language"):    return "language"
      case i18n.tr("Votes"):       return "votes"
      case i18n.tr("Click count"): return "clickcount"
      case i18n.tr("Random"):      return "random"
      case i18n.tr("Name"):        break
      }

      return "name"
   }
}
