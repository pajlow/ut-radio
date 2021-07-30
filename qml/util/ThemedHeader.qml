import QtQuick 2.0
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3

import "../colors"

Rectangle {
   property string title

   id: header
   anchors.left: parent.left
   anchors.right: parent.right
   anchors.top: parent.top
   height: units.gu(6.1)
   color: Colors.surfaceColor

   ListItem {
      anchors.fill: parent
      color: Colors.surfaceColor
      divider.visible: false

      SlotsLayout {
         mainSlot: Text {
            text: title
            font.pointSize: units.gu(1.9)
            color: Colors.mainText
            SlotsLayout.overrideVerticalPositioning: true
            anchors.verticalCenter: parent.verticalCenter
         }
         Icon {
            width: units.gu(2)
            height: units.gu(2)
            SlotsLayout.position: SlotsLayout.Leading;
            SlotsLayout.padding.leading: 0
            SlotsLayout.padding.trailing: 0
            SlotsLayout.overrideVerticalPositioning: true
            anchors.verticalCenter: parent.verticalCenter

            color: Colors.mainText
            name: "toolkit_chevron-rtl_3gu"

            MouseArea {
               anchors.fill: parent
               onClicked: pageStack.pop()
            }
         }
      }
   }

   Rectangle {
      id: separator
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      height: 1
      color: Colors.borderColor
   }
}
