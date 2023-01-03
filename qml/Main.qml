import "./notify"
import Lomiri.Components 1.3
import Qt.labs.settings 1.0
import QtQuick 2.7
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2

MainView {
    id: root

    objectName: 'mainView'
    applicationName: 'radio.s710'
    automaticOrientation: false
    width: units.gu(45)
    height: units.gu(75)
    Component.onCompleted: pageStack.push(Qt.resolvedUrl("pages/MainPage.qml"))

    Notification {
        notificationId: "notification"
    }

    PageStack {
        id: pageStack

        anchors {
            fill: parent
        }

    }

}
