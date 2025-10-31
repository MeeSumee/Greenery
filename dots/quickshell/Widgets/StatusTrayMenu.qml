import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.Data as Dat

IconImage {
  id: root
  required property SystemTrayItem item

  source: root.item.icon ?? "../Assets/nahidaj.gif"
  implicitSize: 30
  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton
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
