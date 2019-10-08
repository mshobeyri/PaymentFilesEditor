import QtQuick 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls 2.12

Dialog {
    id: iroot

    height: icol.height+50 +header.height
    width: icol.width+50
    anchors.centerIn: parent
    dim: true
    modal: true
    title: "Are u sure"
    closePolicy: Popup.NoAutoClose
    property var acceptFunc
    property var rejectFunc
    function openAndDo(func,rejfunc){
        acceptFunc = func
        rejectFunc = rejfunc
        iroot.open()
    }

    Column{
        id: icol
        spacing: 0

        Label{
            text: "You will lost your current data, Are you sure about doing that?"
        }
        Item{
            width: 20
            height: 20
        }
        Row{
            spacing: 10
            anchors.right: parent.right
            Button{
                text: "No, I'm not"
                onClicked: {
                    if(rejectFunc)
                        rejectFunc()
                    iroot.close()
                }
            }
            Button{
                text: "Yes, I am"
                highlighted: true
                Universal.accent: Universal.Steel
                onClicked: {
                    acceptFunc()
                    iroot.close()
                }
            }
        }
    }
}
