import QtQuick 2.12

Timer {
    id: itimer
    interval: 10
    repeat: false
    running: false
    property var callFunc
    function doit(func){
        callFunc = func
        itimer.start()
    }
    onTriggered: callFunc()
}
