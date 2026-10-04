import QtQuick
import "behaviors"

Item {
    id: mascotHostRoot
    width: 116; height: 116
    readonly property alias dogState: controller.dogState
    property var targetWindow: null; property var appController: null
    signal clicked(); signal hoverEntered(); signal hoverExited(); signal showTime()

    function setDogState(state) { controller.dogState = state }
    function wakeUp() { controller.triggerWakeAndBark() }

    MascotInteractionController { id: controller; mascotRig: rig }
    PlayfulBehavior { mascotRig: rig; dogState: controller.dogState }
    HoverGreetingFlow { id: hoverFlow; mascotRig: rig; isHoverActive: mouseArea.containsMouse; dogState: controller.dogState; isBeingPetted: controller.isBeingPetted }

    Timer {
        interval: 1000; repeat: true; running: true; property int lastCheckedHour: -1
        onTriggered: {
            var now = new Date(); var h = now.getHours(); var m = now.getMinutes();
            if (m === 0 && h !== lastCheckedHour) { lastCheckedHour = h; mascotHostRoot.showTime(); }
        }
    }

    DogRigMascot {
        id: rig; anchors.fill: parent; dogState: controller.dogState; isHovered: mouseArea.containsMouse
        springEarL: mascotHostRoot.appController?.physics?.earAngleL ?? 0
        springEarR: mascotHostRoot.appController?.physics?.earAngleR ?? 0
        springTail: mascotHostRoot.appController?.physics?.tailAngle ?? 0
        springTag: mascotHostRoot.appController?.physics?.nameTagAngle ?? 0
        physicsSquashX: mascotHostRoot.appController?.physics?.squashX ?? 1.0
        physicsSquashY: mascotHostRoot.appController?.physics?.squashY ?? 1.0
    }

    MascotWindowTracker {
        targetWindow: mascotHostRoot.targetWindow
        appController: mascotHostRoot.appController
        rig: rig
    }

    DragHandler {
        target: null
        onActiveChanged: if (active) {
            controller.triggerWakeAndBark();
            if (mascotHostRoot.targetWindow) mascotHostRoot.targetWindow.startSystemMove();
        }
    }

    MouseArea {
        id: mouseArea; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        property real lastX: -1; property real lastY: -1
        onPositionChanged: (mouse) => {
            if (controller.dogState === "sleeping") return;
            if (lastX >= 0 && lastY >= 0) {
                var dist = Math.hypot(mouse.x - lastX, mouse.y - lastY);
                if (dist > 1 && dist < 45) controller.recordPetting(mouse.x, mouse.y, dist);
            }
            lastX = mouse.x; lastY = mouse.y;
            var dx = (mouse.x - width / 2) / (width / 2); var dy = (mouse.y - height / 2) / (height / 2);
            rig.gazeX = Math.max(-2.5, Math.min(2.5, dx * 2.5)); rig.gazeY = Math.max(-2.0, Math.min(2.0, dy * 2.0));
            rig.isTrackingMouse = true;
        }
        onEntered: { lastX = -1; lastY = -1; rig.isTrackingMouse = true; if (controller.dogState === "active") hoverFlow.triggerHoverFlow(); mascotHostRoot.hoverEntered(); }
        onExited: { lastX = -1; lastY = -1; rig.isTrackingMouse = false; rig.gazeX = 0; rig.gazeY = 0; controller.handleMouseLeave(); mascotHostRoot.hoverExited(); }
        onClicked: (mouse) => { controller.triggerWakeAndBark(); rig.jumpAndBounce(); mascotHostRoot.clicked(); }
    }
}
