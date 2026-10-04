import QtQuick
import "mascot"
import "mascot/behaviors"
import "chat"

Window {
    id: assistantWindow
    property var appController: null; property bool isPinned: true
    property bool initialized: false; property bool isMovingDog: false
    readonly property bool isExpanded: !!(appController && appController.isExpanded)

    visible: true; color: "transparent"
    width: isExpanded ? 400 : 126; height: isExpanded ? 706 : 116
    flags: isPinned ? (Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint)
                    : (Qt.Tool | Qt.FramelessWindowHint)

    Timer { id: savePosTimer; interval: 400; repeat: false; onTriggered: if (appController && initialized && !isMovingDog) appController.savePosition(x + (isExpanded ? 274 : 0), y + (isExpanded ? 590 : 0)) }
    onXChanged: if (initialized && !isMovingDog) savePosTimer.restart()
    onYChanged: if (initialized && !isMovingDog) savePosTimer.restart()

    onIsExpandedChanged: {
        if (!initialized) return
        if (isExpanded) { x -= 274; y -= 590; Qt.callLater(chatPanel.focusInput) }
        else { x += 274; y += 590 }
    }

    function updateWindowPos() {
        var sW = Screen.desktopAvailableWidth > 0 ? Screen.desktopAvailableWidth : Screen.width
        var sH = Screen.desktopAvailableHeight > 0 ? Screen.desktopAvailableHeight : Screen.height
        var dpr = Screen.devicePixelRatio || 1.0
        var dpi = Screen.logicalPixelDensity > 0 ? Screen.logicalPixelDensity * 25.4 : 96.0
        if (appController) appController.saveDisplayMetrics(dpr, dpi)
        var margin = 10; var defDogX = sW - 126 - margin; var defDogY = sH - 116 - margin
        var p = appController ? appController.getSavedPosition(defDogX, defDogY) : Qt.point(defDogX, defDogY)
        var dogX = (p.x <= 10 || p.x > sW - 126) ? defDogX : p.x
        var dogY = (p.y <= 10 || p.y > sH - 116) ? defDogY : p.y
        x = isExpanded ? dogX - 274 : dogX; y = isExpanded ? dogY - 590 : dogY
        Qt.callLater(() => { initialized = true; })
    }
    Component.onCompleted: { updateWindowPos(); dogHost.wakeUp(); }

    ChatPanel {
        id: chatPanel; anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter
        visible: assistantWindow.isExpanded; appController: assistantWindow.appController
        hostWindow: assistantWindow; isPinned: assistantWindow.isPinned
        onPinToggled: assistantWindow.isPinned = !assistantWindow.isPinned
    }

    Item {
        id: mascotAnchorArea; width: 126; height: 116
        anchors.bottom: parent.bottom; anchors.right: parent.right
        HoverHandler {
            onHoveredChanged: if (hovered) { hideTimer.stop(); actionBar.isVisible = true; } else hideTimer.restart()
        }
        Timer { id: hideTimer; interval: 450; repeat: false; onTriggered: actionBar.isVisible = false }

        DogMascotHost {
            id: dogHost; width: 116; height: 116; targetWindow: assistantWindow
            appController: assistantWindow.appController
            onClicked: if (assistantWindow.isMovingDog) assistantWindow.isMovingDog = false;
                       else if (appController) appController.isExpanded = !appController.isExpanded
        }

        MascotActionBar {
            id: actionBar; x: 96; anchors.verticalCenter: dogHost.verticalCenter
            isDragArmed: assistantWindow.isMovingDog
            onTriggerDrag: assistantWindow.isMovingDog = !assistantWindow.isMovingDog
            onTriggerSettings: if (appController) appController.isExpanded = !appController.isExpanded
            onTriggerExit: if (appController) appController.quitApp(); else Qt.quit()
        }
    }

    MascotFollowMover {
        targetWindow: assistantWindow; appController: assistantWindow.appController
        isMoving: assistantWindow.isMovingDog
    }
}
