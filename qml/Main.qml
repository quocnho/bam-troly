import QtQuick
import "mascot"
import "mascot/behaviors"
import "chat"
import "common"

Window {
    id: dogWindow
    property var appController: null
    property bool isPinned: true
    property bool initialized: false

    visible: true; width: 148; height: 116; color: "transparent"
    flags: isPinned ? (Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint)
                    : (Qt.Window | Qt.FramelessWindowHint)

    Timer { id: savePosTimer; interval: 400; repeat: false; onTriggered: if (appController && initialized) appController.savePosition(dogWindow.x, dogWindow.y) }
    onXChanged: { if (initialized) savePosTimer.restart(); if (chatWin && chatWin.visible) chatWin.realignToDog(); }
    onYChanged: { if (initialized) savePosTimer.restart(); if (chatWin && chatWin.visible) chatWin.realignToDog(); }

    function updateDogPos() {
        var sW = Screen.desktopAvailableWidth > 0 ? Screen.desktopAvailableWidth : Screen.width;
        var sH = Screen.desktopAvailableHeight > 0 ? Screen.desktopAvailableHeight : Screen.height;
        var defX = sW - width - 24; var defY = sH - height - 24;
        if (appController) {
            var p = appController.getSavedPosition(defX, defY);
            if (p.x <= 10 || p.x > sW - width || p.y <= 10 || p.y > sH - height) { x = defX; y = defY; } else { x = p.x; y = p.y; }
        } else { x = defX; y = defY; }
        initialized = true;
    }
    Component.onCompleted: { updateDogPos(); mascotDog.wakeUp(); }
    Screen.onWidthChanged: updateDogPos(); Screen.onHeightChanged: updateDogPos()

    HoverHandler {
        id: winHover
        onHoveredChanged: if (!hovered) hideTimer.restart()
    }
    Timer { id: hideTimer; interval: 350; repeat: false; onTriggered: if (!winHover.hovered) actionBar.isVisible = false }

    DogMascotHost {
        id: mascotDog; width: 116; height: 116; targetWindow: dogWindow; appController: dogWindow.appController
        onHoverEntered: { hideTimer.stop(); actionBar.isVisible = true }
        onDogStateChanged: if ((dogState === "lying" || dogState === "sleeping") && appController && appController.isExpanded) appController.isExpanded = false
        onClicked: if (appController) {
            appController.isExpanded = !appController.isExpanded
            if (appController.isExpanded) Qt.callLater(chatWin.focusInput)
        }
    }

    MascotActionBar {
        id: actionBar; x: 116; anchors.verticalCenter: mascotDog.verticalCenter
        onHoverEntered: hideTimer.stop()
        onTriggerDrag: dogWindow.startSystemMove()
        onTriggerSettings: if (appController) {
            appController.isExpanded = !appController.isExpanded
            if (appController.isExpanded) Qt.callLater(chatWin.focusInput)
        }
        onTriggerExit: if (appController) appController.quitApp(); else Qt.quit()
    }

    FloatingChatWindow {
        id: chatWin; visible: !!(appController && appController.isExpanded)
        appController: dogWindow.appController; dogWindow: dogWindow
        isPinned: dogWindow.isPinned; onPinToggled: dogWindow.isPinned = !dogWindow.isPinned
    }
}
