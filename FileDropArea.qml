import QtQuick 2.12
import QtQuick.Controls 2.12

DropArea {
      id: idrop
      enabled: true
      signal droped(var drop)
      property alias text: ilabel.text
      property alias visibleArea: irect.visible
      Rectangle{
          id: irect
          anchors.fill: parent
          opacity: idrop.containsDrag?1:0.6
          Behavior on opacity {
              NumberAnimation{duration: 400}
          }

          color: "white"
          Rectangle{
              anchors.fill: parent
              anchors.margins: 20
              border.width: 4
              border.color: "midnightblue"
          }
          Label{
              id: ilabel
              font.pointSize: 18
              color: "midnightblue"
              anchors.centerIn: parent
              font.bold: true
          }
      }

      onDropped:
         idrop.droped(drop)
  }
