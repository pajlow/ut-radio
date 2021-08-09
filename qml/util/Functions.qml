pragma Singleton

import QtQuick 2.0
import Qt.labs.settings 1.0

import "../notify"

Item {
   property var favouriteModel

   Settings {
      id: settings
      property string favouriteStations: "{}"
   }

   function init() {
      var s

      try {
         s = JSON.parse(settings.value("favouriteStations"))
      } catch (e) {
         s = {}
      }

      for (var key in s) {
         favouriteModel.append(s[key])
      }
   }

   function saveFavourite(station) {
      var s

      try {
         s = JSON.parse(settings.value("favouriteStations"))
      } catch (e) {
         s = {}
      }

      if (s[station.stationID]) {
         Notify.warning(i18n.tr("Favourites"), i18n.tr("URL for station has already been added as favourite"))
         return
      }

      station.favourite = true
      s[station.stationID] = station
      favouriteModel.append(JSON.parse(JSON.stringify(station)))

      settings.setValue("favouriteStations", JSON.stringify(s))
   }

   function removeFavourite(stationID) {
      var s

      try {
         s = JSON.parse(settings.value("favouriteStations"))
      } catch (e) {
         s = {}
      }

      delete s[stationID]

      for (var i = 0; i < favouriteModel.count; i++) {
         var station = favouriteModel.get(i)

         if (station.stationID === stationID) {
            favouriteModel.remove(i)
            break
         }
      }

      settings.setValue("favouriteStations", JSON.stringify(s))
   }

   function hasFavourite(stationID) {
      var s

      try {
         s = JSON.parse(settings.value("favouriteStations"))
      } catch (e) {
         s = {}
      }

      return s.hasOwnProperty(stationID)
   }
}
