import "../colors"
import Lomiri.Components 1.3
import Lomiri.Components.ListItems 1.3
import QtQuick 2.0

Rectangle {
    id: header

    property string title

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
            Icon {
                width: units.gu(2)
                height: units.gu(2)
                SlotsLayout.position: SlotsLayout.Leading
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

            mainSlot: Text {
                text: title
                font.pointSize: units.gu(1.9)
                color: Colors.mainText
                SlotsLayout.overrideVerticalPositioning: true
                anchors.verticalCenter: parent.verticalCenter
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
