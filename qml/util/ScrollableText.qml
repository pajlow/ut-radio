import QtQuick 2.5

Text {
   id: scrollableText
   readonly property string spacing: "     "
   property string displayText: ""
   property string displayTextWithSpacing: displayText + spacing
   property string displayTextCurrent: displayTextWithSpacing.substring(step) + displayTextWithSpacing.substring(0, step)
   property int step: 0
   clip: true

   text: displayTextCurrent

   onDisplayTextChanged: {
      textMetrics.text = displayText
      scrollTimer.running = textMetrics.tightBoundingRect.width > scrollableText.width
   }

   horizontalAlignment: Text.AlignHCenter

   Timer {
      id: scrollTimer
      interval: 200
      running: false
      repeat: true
      onTriggered: {
         parent.step = (parent.step + 1) % parent.displayTextWithSpacing.length
      }
   }

   TextMetrics {
       id:     textMetrics
       font:   scrollableText.font
       text:   scrollableText.displayText
   }
}
