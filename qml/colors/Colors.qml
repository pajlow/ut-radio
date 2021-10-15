pragma Singleton

import QtQuick 2.0
import Qt.labs.settings 1.0

Item {
   Settings {
      id: settings
      property bool darkMode: true
   }

   property color backgroundColor: settings.darkMode ? "#121212" : "white"
   property color surfaceColor: settings.darkMode ? "#292929" : "white"
   property color surfaceColor2:  settings.darkMode ? "#3b3b3b" : "white"
   property color borderColor: settings.darkMode ? "#121212" : "#e3e3e3"
   property color highlightColor: settings.darkMode ? "#313131" : "gray"

   property color mainText: settings.darkMode ? "#e3e3e3" : "black"
   property color detailText: settings.darkMode ? "#acacac" : "gray"
   property color accentText: settings.darkMode ? "#538cc6" : "#336699"
}
