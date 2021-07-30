import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3
import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtMultimedia 5.12
import Qt.labs.settings 1.0

import "../net"
import "../util"
import "../notify"
import "../colors"

Rectangle {
   id: mainPage
   anchors.fill: parent
   property var padding: units.gu(3)
   property bool netReady: false
   property bool resumeAfterSuspend: false
   property var lastStation

   color: Colors.backgroundColor

   Settings {
      id: settings
      property string lastStation: "{}"
   }

   MediaPlayer {
      id: audioPlayer
      audioRole: MediaPlayer.MusicRole
      source: lastStation && lastStation.url || ""

      metaData.onMetaDataChanged: {
         if (metaData.title) {
            stationTitleText.text = metaData.title
            stationTitleText.color = Colors.accentText
         } else {
            stationTitleText.text = textForStatus()
            stationTitleText.color = Colors.detailText
         }
      }

      onPlaybackStateChanged: {
         stationTitleText.text = textForPlaybackStatus()
         stationTitleText.color = Colors.detailText
      }

      onStatusChanged: {
         stationTitleText.text = textForStatus()
         stationTitleText.color = Colors.detailText

         if (status === MediaPlayer.EndOfMedia)
            audioPlayer.play()
      }

      onError: Notify.error(i18n.tr("Error"), error)

      function textForPlaybackStatus() {
         switch (audioPlayer.playbackState) {
         case MediaPlayer.PlayingState: return i18n.tr("Playing")
         case MediaPlayer.StoppedState: return i18n.tr("Stopped")
         case MediaPlayer.PausedState: return i18n.tr("Paused")
         }
      }

      function textForStatus() {
         switch (audioPlayer.status) {
         case MediaPlayer.NoMedia: return i18n.tr("NoMedia")
         case MediaPlayer.Loading: return i18n.tr("Loading")
         case MediaPlayer.Loaded: return textForPlaybackStatus()
         case MediaPlayer.Buffering: return i18n.tr("Buffering")
         case MediaPlayer.Stalled: return i18n.tr("Stalled")
         case MediaPlayer.Buffered: return i18n.tr("Buffered")
         case MediaPlayer.EndOfMedia:
         case MediaPlayer.InvalidMedia:
         case MediaPlayer.UnknownStatus: return textForPlaybackStatus()
         }

         return ""
      }

      function isPlaying() {
         return audioPlayer.playbackState == MediaPlayer.PlayingState
      }
   }

   Connections {
      target: Qt.application

      onAboutToQuit: {
         audioPlayer.stop()
      }

      onStateChanged: {
         switch (Qt.application.state) {
         case Qt.ApplicationActive:
         case Qt.ApplicationInactive:
         case Qt.ApplicationSuspended:
            break;
         case Qt.ApplicationHidden:
            if (!audioPlayer.isPlaying() && resumeAfterSuspend)
               audioPlayer.play()

            break;
         }
      }
    }

   ListModel {
      id: favouriteModel
   }

   Component.onCompleted: {
      Network.init(function(err) {
         netReady = !err

         if (err)
            Notify.error(i18n.tr("Radio Browser"), i18n.tr("Failed to lookup hostname for radio-browser.info. Searching for web streams might be unavailable. Check internet connection and restart app.") + "\n" + err)
      })

      Functions.favouriteModel = favouriteModel
      Functions.init()

      var s
      try {
         s = JSON.parse(settings.value("lastStation"))
         lastStation = s
         lastStation.favourite = Functions.hasFavourite(s.stationID)
         favIcon.name = s.favourite ? "starred" : "non-starred"
      } catch (e) {}
   }

   Column {
      id: playerControls
      anchors.top: parent.top
      anchors.topMargin: mainPage.padding
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: mainPage.padding

      Column {
         anchors.horizontalCenter: parent.horizontalCenter
         spacing: units.gu(1)

         Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: mainPage.padding/2

            Text {
               id: stationText
               anchors.verticalCenter: parent.verticalCenter
               text: lastStation && lastStation.name || i18n.tr("No station")
               font.bold: true
               color: Colors.mainText
            }

            Icon {
               id: favIcon
               height: units.gu(2)
               width: units.gu(2)
               visible: !!lastStation

               MouseArea {
                  anchors.fill: parent
                  onClicked: {
                     lastStation.favourite = !lastStation.favourite
                     favIcon.name = lastStation.favourite ? "starred" : "non-starred"

                     if (!lastStation.favourite)
                        Functions.removeFavourite(lastStation.stationID)
                     else
                        Functions.saveFavourite(lastStation)
                  }
               }
            }
         }
         Text {
            id: stationTitleText
            anchors.horizontalCenter: parent.horizontalCenter
            text: audioPlayer.textForStatus()
         }
      }

      Rectangle {
         width: mainPage.width * 0.6
         height: mainPage.width * 0.6
         anchors.horizontalCenter: parent.horizontalCenter
         color: Colors.backgroundColor

         border.width: 1
         border.color: Colors.borderColor

         Icon {
            anchors.fill: parent
            name: "stock_music"
            visible: !lastStation || !lastStation.image
         }

         Image {
            anchors.fill: parent
            visible: lastStation && lastStation.image || false
            source: lastStation && lastStation.image || ""
            asynchronous: true
         }
      }

      Row {
         anchors.horizontalCenter: parent.horizontalCenter
         spacing: mainPage.padding

         Button {
            width: units.gu(4)
            height: units.gu(4)
            anchors.verticalCenter: parent.verticalCenter

            color: Colors.surfaceColor
            iconName: "toolkit_input-search"
            enabled: mainPage.netReady

            onClicked: {
               var p = pageStack.push(Qt.resolvedUrl("./SearchPage.qml"))
               p.stationChanged.connect(setLastStation)
            }
         }

         Button {
            width: units.gu(6)
            height: units.gu(6)
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.surfaceColor
            iconName: "media-playback-start"
            enabled: !!lastStation

            onClicked: {
               audioPlayer.play()
               mainPage.resumeAfterSuspend = true

               if (!lastStation.manual)
                  Network.countClick(lastStation)
            }
         }

         Button {
            width: units.gu(6)
            height: units.gu(6)
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.surfaceColor
            iconName: "media-playback-stop"
            enabled: !!lastStation

            onClicked: {
               mainPage.resumeAfterSuspend = false
               audioPlayer.stop()
            }
         }

         Button {
            width: units.gu(4)
            height: units.gu(4)
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.surfaceColor
            iconName: "stock_link"
            enabled: mainPage.netReady

            onClicked: {
               var p = pageStack.push(Qt.resolvedUrl("./UrlPage.qml"))
               p.stationChanged.connect(setLastStation)
            }
         }
      }

      Row {
         anchors.horizontalCenter: parent.horizontalCenter
         spacing: mainPage.padding

         Text {
            anchors.verticalCenter: parent.verticalCenter
            text: i18n.tr("Favourites")
            color: Colors.mainText
            font.bold: true
            visible: favouriteModel.count
         }
      }
   }

   ListView {
      id: favList
      anchors.top: playerControls.bottom
      anchors.topMargin: padding/2
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      clip: true

      model: favouriteModel

      delegate: ListItem {
         height: layout.height + (divider.visible ? divider.height : 0)
         color: Colors.surfaceColor
         divider.colorFrom: Colors.borderColor
         divider.colorTo: Colors.borderColor
         highlightColor: Colors.highlightColor

         onClicked: setLastStation(JSON.parse(JSON.stringify(favouriteModel.get(index))))

         trailingActions: ListItemActions {
            actions: [
               Action {
                  iconName: "delete"
                  onTriggered: {
                     Functions.removeFavourite(stationID)
                  }
               }
            ]
         }
         SlotsLayout {
            id: layout
            mainSlot: Label {
               text: name
               color: Colors.mainText
            }
            Image {
               source: image
               SlotsLayout.position: SlotsLayout.Leading;
               width: units.gu(4)
               height: units.gu(4)
               asynchronous: true
            }
         }
      }
   }

   function setLastStation(station) {
      audioPlayer.stop()
      mainPage.lastStation = station
      favIcon.name = lastStation.favourite ? "starred" : "non-starred"
      settings.setValue("lastStation", JSON.stringify(mainPage.lastStation))
      audioPlayer.play()

      Notify.info(i18n.tr("Playing"), station.name || i18n.tr("Web stream"))
   }
}
