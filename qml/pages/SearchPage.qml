import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3
import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtMultimedia 5.12
import Qt.labs.settings 1.0

import "../net"
import "../util"
import "../colors"

Rectangle {
   id: searchPage
   anchors.fill: parent
   signal stationChanged(var station)

   color: Colors.backgroundColor

   ThemedHeader {
      id: header
      title: i18n.tr("Search")
   }

   ListModel {
      id: searchResultsModel
   }

   ListItem {
      id: searchInput
      anchors.top: header.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      color: Colors.surfaceColor
      divider.colorFrom: Colors.borderColor
      divider.colorTo: Colors.borderColor
      highlightColor: Colors.highlightColor

      height: layoutSearchInput.height + (divider.visible ? divider.height : 0)

      SlotsLayout {
         id: layoutSearchInput
         mainSlot: TextField {
            id: searchInputField
            placeholderText: i18n.tr("Enter search term")
            onAccepted: startSearch()
         }
         Button {
            id: buttonLogin
            text: i18n.tr("Search")
            enabled: searchInputField.text.length
            SlotsLayout.position: SlotsLayout.Trailing;
            onClicked: startSearch()
         }
      }
   }

   function startSearch() {
      searchResultsModel.clear()

      Network.searchStation(searchInputField.text, function(err, results) {
         if (err)
            Notify.error(i18n.tr("Radio Browser"), i18n.tr("Failed to search for stations at radio-browser.info. Check internet connection.") + "\n" + err)
         else
            (results || []).forEach(function(r) { searchResultsModel.append(r) })
      })
   }

   ListView {
      id: searchResults
      anchors.top: searchInput.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      clip: true

      model: searchResultsModel

      delegate: ListItem {
         height: resultRowLayout.height + (divider.visible ? divider.height : 0)
         color: Colors.surfaceColor
         divider.colorFrom: Colors.borderColor
         divider.colorTo: Colors.borderColor
         highlightColor: Colors.highlightColor

         onClicked: {
            pageStack.pop()
            emit: stationChanged(JSON.parse(JSON.stringify(searchResultsModel.get(index))))
         }

         SlotsLayout {
            id: resultRowLayout
            mainSlot: Text {
               text: name
               color: Colors.mainText
               clip: true
            }
            Image {
               source: image
               SlotsLayout.position: SlotsLayout.Leading;
               width: units.gu(4)
               height: units.gu(4)
               asynchronous: true
            }
            Icon {
               id: favButton
               width: units.gu(4)
               height: units.gu(4)
               SlotsLayout.position: SlotsLayout.Trailing;
               name: favourite ? "starred" : "non-starred"

               MouseArea {
                  anchors.fill: parent
                  onClicked: {
                     searchResultsModel.setProperty(index, "favourite", !favourite)

                     if (!favourite) {
                        Functions.removeFavourite(stationID)
                     } else {
                        Functions.saveFavourite(searchResultsModel.get(index))
                     }
                  }
               }
            }
         }
      }
   }
}
