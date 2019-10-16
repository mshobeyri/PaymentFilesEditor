import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Layouts 1.12

Dialog {
    id: iroot
    width: parent.width / 1.5
    height: parent.height / 1.5
    anchors.centerIn: parent
    dim: true
    title: "Read file error"
    closePolicy: "NoAutoClose"
    function openWithModel(model){
        ilview.model = model
        iroot.open()
    }

    ColumnLayout{
        id: icol
        anchors.fill: parent
        ListView{
            id: ilview
            Layout.fillWidth: true
            Layout.fillHeight: true
            model :[]
            clip: true
            delegate: Column{
                width: parent.width
                Row{
                    id: irow
                    spacing: 10
                    width: parent.width
                    Label{
                        text: ""
                        font.family: ifontAwsome.name
                        Universal.foreground: Universal.Red
                        anchors.verticalCenter: parent.verticalCenter
                        width: paintedWidth
                    }
                    Label{
                        text: model.modelData
                        anchors.verticalCenter: parent.verticalCenter
                        width: iroot.width - 100
                        wrapMode: "WrapAnywhere"
                    }
                }
                MenuSeparator{
                    width: parent.width
                }
            }
        }
        Button{
            text: "Ok, Got that"
            Layout.alignment: Qt.AlignRight
            onClicked: {
                iroot.close()
                ilview.model = []
            }
        }
    }
}
