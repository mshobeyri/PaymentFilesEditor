import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Universal 2.12
import Qt.labs.settings 1.1
import "utils.js" as Util

Pane{
    Layout.preferredWidth: 340
    Layout.fillHeight: true
    padding: 5
    property alias searchBox: isearchTextField
    property alias description: idescription

    function goNormalMode(){
        searchBox.text = ""
    }

    Settings{
        property alias description: idescription.text
        property alias realTimeSearch: irealTimeSearchSw.checked
    }
    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 10
        Flickable{
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 10
            Layout.rightMargin: 0
            contentHeight: icol.height
            clip: true
            interactive: height < contentHeight
            ScrollBar.vertical: ScrollBar {
                id: iscroll
                Layout.alignment: Qt.AlignRight
            }

            ColumnLayout{
                id: icol
                width: parent.width - iscroll.width - 5
                Label{
                    Layout.bottomMargin: -5
                    Layout.topMargin: 10
                    Universal.foreground: Universal.Cobalt
                    font.pointSize: 12
                    text: "Search"
                }
                MenuSeparator{
                    Layout.fillWidth: true
                    leftPadding: 0
                    rightPadding: 0
                }
                TextField{
                    id: isearchTextField
                    Layout.fillWidth: true
                    placeholderText: "Search here..."
                    maximumLength: 20
                    selectByMouse: true
                    onAccepted: {
                        searchElement()
                    }
                    onTextChanged: {
                        if(irealTimeSearchSw.checked && text!==""){
                            searchElement()
                        }
                        if(text===""){
                            ilistview.model = imodel
                            searchText = ""
                        }
                    }

                    Button{
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        text: ""
                        font.family: ifontAwsome.name
                        height: parent.height
                        width: height
                        highlighted: true
                        hoverEnabled: !irealTimeSearchSw.checked
                        Universal.accent : !irealTimeSearchSw.checked?Universal.Steel:"#00000000"
                        onClicked: if(!irealTimeSearchSw.checked) searchElement()
                    }
                }

                RowLayout{
                    Switch{
                        id: irealTimeSearchSw
                        onCheckedChanged: {
                            if(isearchTextField.text!=="" && checked)
                                searchElement()
                        }
                    }
                    Label{
                        text: "Real Time Search"
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
                Label{
                    Layout.topMargin: 10

                }
                Label{
                    Layout.bottomMargin: -5
                    Layout.topMargin: 10
                    Universal.foreground: Universal.Cobalt
                    font.pointSize: 12
                    text: "Menu"
                }
                MenuSeparator{
                    Layout.fillWidth: true
                    leftPadding: 0
                    rightPadding: 0
                }
                RowLayout{
                    Button{
                        text: ""
                        Layout.fillWidth: true
                        font.family: ifontAwsome.name
                        onClicked: openFileDialog(false)
                        ToolTip.text: "Open"
                        ToolTip.visible: hovered
                    }
                    Button{
                        text: ""
                        font.family: ifontAwsome.name
                        Layout.fillWidth: true
                        onClicked: openFileDialog(true)
                        ToolTip.text: "Append"
                        ToolTip.visible: hovered
                        enabled: imodel.count > 0
                    }
                    Button{
                        text: ""
                        Layout.fillWidth: true
                        font.family: ifontAwsome.name
                        onClicked: openSaveFileDialog()
                        ToolTip.text: "SaveAs"
                        ToolTip.visible: hovered
                        enabled: imodel.count > 0
                    }

                }


                Label{
                    Layout.bottomMargin: -5
                    Layout.topMargin: 20
                    Universal.foreground: Universal.Cobalt
                    font.pointSize: 12
                    text: "description"

                }
                MenuSeparator{
                    Layout.fillWidth: true
                    leftPadding: 0
                    rightPadding: 0
                }
                TextField{
                    id: idescription
                    text: ""
                    Layout.fillWidth: true
                    selectByMouse: true
                    onTextChanged: {
                        text = text.replace("]","")
                        text = text.replace("[","")
                        text = text.replace("=","")
                    }
                }

                Label{
                    Layout.bottomMargin: -5
                    Layout.topMargin: 20
                    Universal.foreground: Universal.Cobalt
                    font.pointSize: 12
                    text: "Add"
                }
                MenuSeparator{
                    Layout.fillWidth: true
                    leftPadding: 0
                    rightPadding: 0
                }

                TextField{
                    id: ibankAccount
                    Layout.fillWidth: true
                    color: text.length < 10? "red": "black"
                    maximumLength: 10
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: RegExpValidator{regExp: /\d+/}
                    selectByMouse: true
                }
                TextField{
                    id: imoney
                    Layout.fillWidth: true
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: RegExpValidator{regExp: /\d+/}
                    selectByMouse: true
                }
                RowLayout{
                    Button{
                        text: "Add as first"
                        Layout.fillWidth: true
                        onClicked: {
                            filesEdited = true
                            imodel.insert(0,{"acnumber": ibankAccount.text,
                                              "money": Number(imoney.text)})
                            totalPrice+= Number(imoney.text)
                            if(searchMode)searchElement()
                        }
                    }
                    Button{
                        text: "Add as last"
                        Layout.fillWidth: true
                        onClicked: {
                            filesEdited = true
                            imodel.append({"acnumber": ibankAccount.text,
                                              "money": Number(imoney.text)})
                            totalPrice+= Number(imoney.text)
                            if(searchMode)searchElement()
                        }
                    }
                }

                Item{
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }

        MenuSeparator{
            Layout.fillWidth: true
            leftPadding: 0
            rightPadding: 0
            bottomPadding: 0
        }
        RowLayout{
            Layout.fillWidth: true

            Button{
                Universal.accent: "white"
                Layout.preferredWidth: height
                Layout.preferredHeight: 25
                highlighted: true
                topInset: 0
                ToolTip.text: "About"
                ToolTip.visible: hovered
                onClicked: iaboutDialog.open()
                Image{
                    mipmap: true
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                    source: "qrc:/res/bitmap.png"
                }
            }

            Label{
                Layout.fillWidth: true
                text: "total: "+imodel.count+", total price:"+ Util.numberWithCommas(totalPrice)
            }
        }
    }
}
