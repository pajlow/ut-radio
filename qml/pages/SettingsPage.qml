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

    Settings {
       id: settings
       property bool darkMode: true
    }

    ThemedHeader {
       id: header
       title: i18n.tr("Settings")
    }

    Flickable {
       anchors.top: header.bottom
       anchors.left: parent.left
       anchors.right: parent.right
       anchors.bottom: parent.bottom

       contentWidth: parent.width
       contentHeight: childrenRect.height

       clip: true

       Column {
          anchors.left: parent.left
          anchors.right: parent.right

          ListItem {
             height: l1.height + (divider.visible ? divider.height : 0)
             color: Colors.surfaceColor
             divider.colorFrom: Colors.borderColor
             divider.colorTo: Colors.borderColor
             highlightColor: Colors.highlightColor

             ListItemLayout {
                id: l1
                title.text: i18n.tr("Appearance")
                title.font.bold: true
                title.color: Colors.mainText
                subtitle.text: i18n.tr("Restart the app after changing dark mode option")
                subtitle.color: "red"
                subtitle.visible: false
             }
          }

          ListItem {
              anchors.left: parent.left
              anchors.right: parent.right
              color: Colors.surfaceColor
              divider.colorFrom: Colors.borderColor
              divider.colorTo: Colors.borderColor
              highlightColor: Colors.highlightColor

              height: l2.height + (divider.visible ? divider.height : 0)

              SlotsLayout {
                  id: l2
                  mainSlot: Text {
                     anchors.verticalCenter: parent.verticalCenter
                     text: i18n.tr("Dark mode:")
                     color: Colors.mainText
                  }
                  Switch {
                     checked: settings.darkMode
                     SlotsLayout.position: SlotsLayout.Trailing

                     onClicked: {
                        settings.darkMode = checked
                        l1.subtitle.visible = true
                     }
                  }
              }
          }
       }
    }
}
