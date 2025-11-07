import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.Data as Dat

Rectangle {
  id: root
  required property SystemTrayItem item
  height: 30
  width: 30
  color: "transparent"
  opacity: 1

  Behavior on opacity {
    NumberAnimation {
      duration: Dat.MaterialEasing.standardAccelTime
      easing.bezierCurve: Dat.MaterialEasing.standardAccel
    }
  }

  IconImage {
    source: root.item.icon
    implicitSize: parent.height

    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      hoverEnabled: true
      onExited: root.opacity = 1
      onEntered: root.opacity = 0.4
      onClicked: event => {
        switch (event.button) {
          case Qt.LeftButton: root.item.activate(); break;
          case Qt.RightButton: 
          if (root.item.hasMenu) {
            const window = QsWindow.window;
            const widgetRect = window.contentItem.mapFromItem(root, 0, root.height + 10 , root.width, root.height);
            menuAnchor.anchor.rect = widgetRect;
            menuAnchor.open();
          } 
          break;
        }
      }
    }

    QsMenuAnchor {
      id: menuAnchor
      menu: root.item.menu
      anchor.window: root.QsWindow.window ?? null
    }
  }
}
