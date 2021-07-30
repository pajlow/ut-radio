import QtQuick 2.7
import Ubuntu.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.Window 2.2

import "./notify"

MainView {
   id: root
   objectName: 'mainView'
   applicationName: 'radio.s710'
   automaticOrientation: false

   Notification {
      notificationId: "notification"
   }

   width: units.gu(45)
   height: units.gu(75)

   PageStack {
      id: pageStack
      anchors {
         fill: parent
      }
   }

   Component.onCompleted: pageStack.push(Qt.resolvedUrl("pages/MainPage.qml"))
}
