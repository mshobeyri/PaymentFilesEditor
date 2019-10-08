import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Universal 2.12
import "utils.js" as Util

ListView {
    id: ilistview
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.margins: 10
    onFocusChanged: {
        if(!focus && currentRaw!==undefined)
            currentRaw.disable()
    }
    Label{
        anchors.centerIn: parent
        text: "No Element"
        visible: imodel.count === 0 && !ibusyIndicator.running && !inoElementInSearch.visible
        Universal.foreground: Universal.Cobalt
    }
    Label{
        id: inoElementInSearch
        anchors.centerIn: parent
        text: "No Element Found"
        visible: isearchModel.count === 0 && !ibusyIndicator.running && searchMode
        Universal.foreground: Universal.Cobalt
    }

    ScrollBar.vertical: ScrollBar {
        visible: imodel.count !== 0
        parent: ilistview.parent
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignRight
        Keys.onUpPressed: scrollBar.decrease()
        Keys.onDownPressed: scrollBar.increase()
        snapMode: ScrollBar.SnapAlways
        policy: ScrollBar.AlwaysOn
    }

    delegate: Item{
        width: ilistview.width
        height: 40
        RowLayout{
            id: irawLayout
            function disable(){
                iaccountTextField.focus = false
                imoneyTextField.focus = false
            }

            anchors.fill: parent
            TextField{
                id: iaccountTextField
                Layout.fillWidth: true
                text: model.acnumber
                maximumLength: 10
                inputMethodHints: Qt.ImhDigitsOnly
                function updateAccount(){
                    if(focus){
                        currentRaw = irawLayout
                    }else{
                        if(model.acnumber === text)
                            return
                        filesEdited = true
                        model.acnumber = text
                        if(searchMode)
                            imodel.setProperty(model.mainindex, "acnumber" , model.acnumber)
                    }
                }

                onFocusChanged: {
                    updateAccount()
                }
                validator: RegExpValidator{regExp: /\d+/}
                selectByMouse: true
                color: text.length < 10? "red": "black"
            }
            TextField{
                id: imoneyTextField
                Layout.fillWidth: true
                text: Util.numberWithCommas(model.money.toString())
                maximumLength: 20
                inputMethodHints: Qt.ImhDigitsOnly
                validator: RegExpValidator{regExp: /\d+/}
                onAccepted: focus = false
                property var lastPrice
                function updateNumber(){
                    if(focus){
                        text = model.money
                        currentRaw = irawLayout
                        lastPrice = model.money
                    }else{

                        model.money = Number(text)
                        if(lastPrice!==model.money)
                            filesEdited = true
                        text = Util.numberWithCommas(model.money)
                        totalPrice -= lastPrice
                        totalPrice += model.money
                        if(searchMode)
                            imodel.setProperty(model.mainindex, "money" , model.money)
                    }
                }

                onFocusChanged: {
                    updateNumber()
                }

                selectByMouse: true
            }
            Button{
                Layout.preferredHeight: 28
                Layout.preferredWidth: height
                text: ""
                font.family: ifontAwsome.name
                onClicked: {
                    totalPrice-= model.money
                    filesEdited = true
                    if(searchMode){
                        imodel.setProperty(model.mainindex,"removed",true)
                        anyThingRemovedInSearchMode = true
                        isearchModel.remove(model.index,1)
                    }else{
                        imodel.remove(model.index,1)
                    }
                }
            }
            Item{
                Layout.preferredWidth: 10
                Layout.preferredHeight: 10
            }
        }
    }

    model :imodel
}
