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

   function searchStation(searchTerm, cb) {
      if (!baseUrl)
         return cb(i18n.tr("Base URL unavailable"))

      var request = new XMLHttpRequest()

      request.open('GET', baseUrl + "/json/stations/byname/" + encodeURIComponent(searchTerm), true);
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
                     favourite: Functions.hasFavourite(x.stationuuid)
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
}
