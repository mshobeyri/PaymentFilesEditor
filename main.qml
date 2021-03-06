import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Universal 2.12
import Qt.labs.platform 1.0 as QLP
import "utils.js" as Util

ApplicationWindow {
    id: win
    visible: true
    width: 900
    height: 650
    minimumHeight: 400
    minimumWidth: 600
    title: filesEdited?qsTr("Payment File Editor*"):qsTr("Payment File Editor")
    property bool appendFlag: false
    property real totalPrice: 0
    property var currentRaw
    property string searchText: ""
    property bool filterInvalids: false
    property string savePath: ""
    property bool anyThingRemovedInSearchMode: false
    property bool filterMode: searchText!=="" || filterInvalids
    property var openFiles: []
    property bool filesEdited: false
    onFilterModeChanged: {
        if(!filterMode){
            removeMarkedElements()
        }
    }

    Component.onCompleted: {
        var openedFilePath = fileManager.getOpenedFilePath()
        if(openedFilePath!==""){
            openFiles.push(openedFilePath)
            idelayWork.doit(openFile)
        }
    }
    onClosing: {
        if(filesEdited){
            close.accepted = false
            iareuSureDialog.openAndDo(function(){
                Qt.quit()
            })
        }
    }

    function removeMarkedElements(){
        if(anyThingRemovedInSearchMode){
            for(var i = imodel.count - 1 ; i>=0 ;i--){
                var element = imodel.get(i)
                if(element.removed){
                    imodel.remove(i)
                }
            }
            anyThingRemovedInSearchMode = false
        }
    }

    function createFile(){
        var body = ""
        var totalPrice = 0
        for(var i=0 ; i< imodel.count;i++){
            var element = imodel.get(i)
            totalPrice += element.money

            body += "\n"+Util.pad(element.acnumber,10)+Util.pad(element.money,15)+Util.pad(0,17)+Util.pad(isidePane.description.text,30," ")

        }
        var header = ""
        header += Util.pad(imodel.count,10)
        header+= Util.pad(totalPrice,15)

        return header+body
    }
    function searchElement(){
        removeMarkedElements()
        ibusyIndicator.running = true
        isearchModel.clear()
        ilistview.model = isearchModel
        searchText = isidePane.searchBox.text
        idelayWork.doit(search)
    }
    function viewInvalids(){
        removeMarkedElements()
        ibusyIndicator.running = true
        isearchModel.clear()
        ilistview.model = isearchModel
        for(var i=0 ; i< imodel.count;i++){
            var element = imodel.get(i)
            if(!element.validAccount){
                isearchModel.append({"acnumber": element.acnumber,
                                        "money": element.money,
                                        "validAccount": element.validAccount,
                                        "mainindex":i})
            }
        }
        ibusyIndicator.running = false
    }
    function search(){
        for(var i=0 ; i< imodel.count;i++){
            var element = imodel.get(i)
            if(element.acnumber.indexOf(searchText)!==-1
                    || element.money.toString().indexOf(searchText)!==-1){
                isearchModel.append({"acnumber": element.acnumber,
                                        "money": element.money,
                                        "validAccount": element.validAccount,
                                        "mainindex":i})
            }
        }
        ibusyIndicator.running = false
    }

    function openFileDialog(append){
        appendFlag = append
        iopenFileDialog.open()
    }

    function openFileAccepted(){
        ibusyIndicator.running = true
        openFiles = []
        for(var i=0;i<iopenFileDialog.files.length;i++){
            openFiles.push(iopenFileDialog.files[i].toString().replace("file:///",""))
        }
        idelayWork.doit(openFile)
    }

    function openFile(){
        if(!appendFlag){
            function openFileCloture(){
                imodel.clear()
                totalPrice = 0
                filesEdited = false
                fileManager.readFiles(openFiles)
                ibusyIndicator.running = false
                if(filterMode)searchElement()
            }

            if(filesEdited){
                iareuSureDialog.openAndDo(openFileCloture,function(){
                    ibusyIndicator.running = false
                })
            }else{
                openFileCloture()
            }
        }else{
            fileManager.readFiles(openFiles)
            ibusyIndicator.running = false
            if(imodel.count!==0)filesEdited = true
            if(filterMode)searchElement()
        }
    }


    function openSaveFileDialog(){
        isidePane.goNormalMode()
        var date = new Date;
        var time = Util.gregorian_to_jalali(date.getFullYear(),date.getMonth()+1,date.getDate())
        var y = Util.pad(time[0]%100,2)
        var m = Util.pad(time[1],2)
        var d = Util.pad(time[2],2)
        var name = "FL"+y+m+d
        var path  = fileManager.openSaveDialog(name);
        if(path!==""){
            savePath = path
            ibusyIndicator.running = true
            idelayWork.doit(saveFile)
        }
    }

    function saveFile(){
        fileManager.writeToFile(savePath,createFile())
        ibusyIndicator.running = false
        filesEdited = false
    }
    function validateACCN(accnumber){
        var checksum = accnumber%100;
        var number = Math.floor(accnumber/100)
        var sum = 0
        var numberstr = number+""
        if(numberstr.length >10)
            return false
        while(numberstr.length<8){
            numberstr = '0'+numberstr
        }
        for(var i=0;i<numberstr.length;i++){
            var n = numberstr.charAt(i);
            sum+= n*(i%2===0?3:7)
        }

        var add = 2 + Math.floor((sum+4)/97);

        var res = (sum+add*2)%99;
        return res === checksum;
    }
    DelayWork{
        id: idelayWork
    }

    Connections{
        target: fileManager
        onNewElement:{
            totalPrice+=money
            imodel.append({"acnumber": acNumber,
                              "money": money,
                              "validAccount":validateACCN(acNumber)
                          })
        }
        onReadError:{
            ierrorDialog.openWithModel(readErrors)
        }
    }

    FontLoader{
        id: ifontAwsome
        source: "qrc:/res/Font Awesome 5 Free-Solid-900.otf"
    }

    QLP.FileDialog{
        id: iopenFileDialog
        fileMode: QLP.FileDialog.OpenFiles
        nameFilters: ["Payment Files(*.pay)"]
        folder: QLP.StandardPaths.writableLocation(QLP.StandardPaths.DocumentsLocation)
        onAccepted: {
            openFileAccepted()
        }
    }

    RowLayout{
        anchors.fill: parent
        SidePane{
            id: isidePane
        }

        ToolSeparator{
            Layout.fillHeight: true
            leftInset: 0
            leftPadding: 0
        }

        AccountsListView{
            id: ilistview

            BusyIndicator{
                id: ibusyIndicator
                width: 60
                height: width
                anchors.centerIn: parent
                running: false
            }
        }
    }

    ListModel {
        id: imodel
    }
    ListModel{
        id: isearchModel
    }
    AboutDialog{
        id: iaboutDialog
    }
    AreUSureDialog{
        id: iareuSureDialog
    }
    ErrorDialog{
        id: ierrorDialog
    }

    ColumnLayout{
        anchors.fill: parent
        spacing: 0
        FileDropArea{
            id: idropOpen
            text: "Release to open"
            Layout.fillWidth: true
            Layout.fillHeight: true
            visibleArea: idropOpen.containsDrag || idropAppend.containsDrag
            property string name: "value"
            onDroped: {
                var openedFilesPath = drop.text.split("\n");
                appendFlag = false
                openFiles = []
                for(var i = 0;i<openedFilesPath.length;i++){
                    (openedFilesPath[i].indexOf(".pay")!==-1)
                    openFiles.push(openedFilesPath[i].replace("file:///",""))
                }
                idelayWork.doit(openFile)
            }
        }
        FileDropArea{
            id: idropAppend
            text: "Release to append"
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: imodel.count > 0
            visibleArea: idropOpen.containsDrag || idropAppend.containsDrag
            onDroped: {
                var openedFilesPath = drop.text.split("\n");
                appendFlag = true
                openFiles = []
                for(var i = 0;i<openedFilesPath.length;i++){
                    (openedFilesPath[i].indexOf(".pay")!==-1)
                    openFiles.push(openedFilesPath[i].replace("file:///",""))
                }
                idelayWork.doit(openFile)
            }
        }
    }
}
