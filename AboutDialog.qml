import QtQuick 2.12
import QtQuick.Controls 2.12

Dialog {
    height: icol.height+50
    width: icol.width+50
    anchors.centerIn: parent
    dim: true
    Column{
        id: icol
        spacing: 0
        Image{
            width: 256
            height: 256
            source: "qrc:/res/bitmap.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Item{
            width: 20
            height: 20
        }

        Label{
            text: "Payment File Editor©\nBy: Baadraan Universal Trading Co\nCopyright (c) 2019 Mehrdad Shobeyri"
        }
        Label{
            color: "midnightblue"
            text: "https://github.com/mshobeyri/PaymentFilesEditor.git"
            font.underline: imareal.containsMouse
            MouseArea{
                id: imareal
                hoverEnabled: true
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("https://github.com/mshobeyri/PaymentFilesEditor.git")
            }
        }
    }
}
