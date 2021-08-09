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
    id: urlPage
    anchors.fill: parent
    signal stationChanged(var station)

    color: Colors.backgroundColor

    ThemedHeader {
       id: header
       title: i18n.tr("Manual stream URL")
    }

    ListModel {
       id: searchResultsModel
    }

    Flickable {
       anchors.top: header.bottom
       anchors.left: parent.left
       anchors.right: parent.right
       anchors.bottom: parent.bottom

       contentWidth: parent.width
       contentHeight: childrenRect.height

       Column {
          anchors.left: parent.left
          anchors.right: parent.right

          ListItem {
              anchors.left: parent.left
              anchors.right: parent.right
              color: Colors.surfaceColor
              divider.colorFrom: Colors.borderColor
              divider.colorTo: Colors.borderColor
              highlightColor: Colors.highlightColor

              height: layout1.height + (divider.visible ? divider.height : 0)

              SlotsLayout {
                  id: layout1
                  mainSlot: TextField {
                      id: urlField
                      inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhUrlCharactersOnly | Qt.ImhNoPredictiveText
                      placeholderText: i18n.tr("Enter stream URL")
                  }
                  Text {
                     width: units.gu(6)
                     SlotsLayout.overrideVerticalPositioning: true
                     anchors.verticalCenter: parent.verticalCenter
                     text: i18n.tr("URL:")
                     color: Colors.mainText
                     SlotsLayout.position: SlotsLayout.Leading
                  }
              }
          }

          ListItem {
              anchors.left: parent.left
              anchors.right: parent.right
              color: Colors.surfaceColor
              divider.colorFrom: Colors.borderColor
              divider.colorTo: Colors.borderColor
              highlightColor: Colors.highlightColor

              height: layout2.height + (divider.visible ? divider.height : 0)

              SlotsLayout {
                  id: layout2
                  mainSlot: TextField {
                      id: nameField
                      placeholderText: i18n.tr("Enter stream name")
                  }
                  Text {
                     width: units.gu(6)
                     SlotsLayout.overrideVerticalPositioning: true
                     anchors.verticalCenter: parent.verticalCenter
                     text: i18n.tr("Name:")
                     color: Colors.mainText
                     SlotsLayout.position: SlotsLayout.Leading
                  }
              }
          }

          ListItem {
              anchors.left: parent.left
              anchors.right: parent.right
              color: Colors.surfaceColor
              divider.colorFrom: Colors.borderColor
              divider.colorTo: Colors.borderColor
              highlightColor: Colors.highlightColor

              height: layout3.height + (divider.visible ? divider.height : 0)

              SlotsLayout {
                  id: layout3
                  mainSlot: TextField {
                      id: imageField
                      inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhUrlCharactersOnly | Qt.ImhNoPredictiveText
                      placeholderText: i18n.tr("Enter URL to station image/artwork")
                  }
                  Text {
                     width: units.gu(6)
                     SlotsLayout.overrideVerticalPositioning: true
                     anchors.verticalCenter: parent.verticalCenter
                     text: i18n.tr("Image:")
                     color: Colors.mainText
                     SlotsLayout.position: SlotsLayout.Leading
                  }
              }
          }

          ListItem {
              anchors.left: parent.left
              anchors.right: parent.right
              color: Colors.surfaceColor
              divider.colorFrom: Colors.borderColor
              divider.colorTo: Colors.borderColor
              highlightColor: Colors.highlightColor

              height: layout4.height + (divider.visible ? divider.height : 0)

              SlotsLayout {
                  id: layout4
                  mainSlot: Button {
                     id: buttonLogin
                     text: i18n.tr("Open stream")
                     enabled: urlField.text.length && nameField.text.length

                     onClicked: {
                        var station = {
                           stationID: Qt.md5(urlField.text),
                           url: urlField.text,
                           name: nameField.text,
                           image: imageField.text,
                           manual: true,
                           favourite: Functions.hasFavourite(Qt.md5(urlField.text))
                        }

                        emit: stationChanged(station)
                        pageStack.pop()
                     }
                 }
              }
          }
       }
    }
}
