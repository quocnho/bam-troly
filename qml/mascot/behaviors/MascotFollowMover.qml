import QtQuick

Timer {
    id: moverRoot
    interval: 16; repeat: true
    property var targetWindow: null
    property var appController: null
    property bool isMoving: false
    running: isMoving

    onTriggered: if (appController && targetWindow) {
        var c = appController.getCursorPos()
        targetWindow.x = c.x - targetWindow.width / 2
        targetWindow.y = c.y - targetWindow.height / 2
    }
}
