pragma Singleton

import QtQuick 2.0

Item {
   id: notifications
   property var queue: []
   property var activeNotification
   property var listener

   function register(notification) {
      listener = notification
   }

   function deregister() {
      listener = undefined
   }

   function info(title, text) {
      addNotification({ type: "info", title, text })
   }

   function warning(title, text) {
      addNotification({ type: "warning", title, text })
   }

   function error(title, text) {
      addNotification({ type: "error", title, text })
   }

   function addNotification(not) {
      if (activeNotification && isSameAs(activeNotification, not))
         return

      queue.push(not)

      if (!activeNotification)
         nextNotification()
   }

   function dismiss() {
      timerAutoDismiss.stop()
      activeNotification = undefined

      if (listener)
         listener.onNotification(activeNotification)

      timerNextNotification.restart()
   }

   function skipAutoDismiss() {
      timerAutoDismiss.stop()
   }

   function nextNotification() {
      activeNotification = queue.shift()

      if (listener)
         listener.onNotification(activeNotification)

      if (activeNotification && activeNotification.type === "info" || activeNotification && activeNotification.type === "warning")
         timerAutoDismiss.start()
   }

   function isSameAs(notification1, notification2) {
      return notification1.type === notification2.type
            && notification1.title === notification2.title
            && notification1.text === notification2.text
   }

   Timer {
      id: timerNextNotification
      interval: 700
      repeat: false
      running: false

      onTriggered: nextNotification()
   }

   Timer {
      id: timerAutoDismiss
      interval: 5000
      repeat: false
      running: false

      onTriggered: dismiss()
   }
}
