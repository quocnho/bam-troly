import QtQuick
import "../parts"

Item {
    id: mascotRoot
    width: 116; height: 116
    property string dogState: "active"
    property bool isBarking: false
    property bool isHovered: false
    property real gazeX: 0; property real gazeY: 0; property bool isTrackingMouse: false
    property real randomPawLift: 0; property bool isLeftPawAction: false
    property real headTilt: 0; property real chestPuff: 1.0; property real bodyBob: 0
    property real squashY: 1.0; property real squashX: 1.0; property real jumpY: 0
    property real physicsSquashX: 1.0; property real physicsSquashY: 1.0
    property real bothPawsLift: 0; property bool isAlert: isHovered || isBarking; property real earFlap: 0
    property bool isLicking: isHovered && dogState !== "sleeping" && dogState !== "lying" && !isBarking
    property real springEarL: 0; property real springEarR: 0; property real springTail: 0; property real springTag: 0
    function bark(showBubble) { barkFlow.play(showBubble === true) }
    function jumpAndBounce() { jumpFlow.play() }

    SequentialAnimation {
        running: !mascotRoot.isBarking && jumpY === 0; loops: Animation.Infinite
        NumberAnimation {
            target: mascotRoot; property: "bodyBob"
            to: mascotRoot.dogState === "sleeping" ? -1.2 : -2.5
            duration: mascotRoot.dogState === "sleeping" ? 1200 : 650; easing.type: Easing.InOutSine
        }
        NumberAnimation {
            target: mascotRoot; property: "bodyBob"; to: 0
            duration: mascotRoot.dogState === "sleeping" ? 1200 : 650; easing.type: Easing.InOutSine
        }
    }

    BarkAnimationFlow { id: barkFlow; target: mascotRoot; barkBubble: barkTextBubble }
    JumpBounceAnimationFlow { id: jumpFlow; target: mascotRoot }

    Item {
        anchors.centerIn: parent
        width: 84; height: 84; y: mascotRoot.bodyBob + mascotRoot.jumpY

        DogTorso {
            dogState: mascotRoot.dogState; isBarking: mascotRoot.isBarking
            chestPuff: mascotRoot.chestPuff
            squashY: mascotRoot.squashY * mascotRoot.physicsSquashY
            squashX: mascotRoot.squashX * mascotRoot.physicsSquashX
            springTailAngle: mascotRoot.springTail
            legLiftRight: mascotRoot.bothPawsLift > 0 ? mascotRoot.bothPawsLift :
                          (mascotRoot.dogState !== "sleeping" ? (!mascotRoot.isLeftPawAction ? mascotRoot.randomPawLift : 0) : 0)
            legLiftLeft: mascotRoot.bothPawsLift > 0 ? mascotRoot.bothPawsLift :
                         (mascotRoot.dogState !== "sleeping" ? (mascotRoot.isLeftPawAction ? mascotRoot.randomPawLift : 0) : 0)
            anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: parent.bottom
        }

        DogHeadAssembly {
            dogState: mascotRoot.dogState; isBarking: mascotRoot.isBarking
            headTiltAngle: mascotRoot.headTilt; isTrackingMouse: mascotRoot.isTrackingMouse
            isAlert: mascotRoot.isAlert; isLicking: mascotRoot.isLicking; earFlap: mascotRoot.earFlap
            springAngleL: mascotRoot.springEarL; springAngleR: mascotRoot.springEarR
            gazeX: mascotRoot.gazeX; gazeY: mascotRoot.gazeY
            anchors.horizontalCenter: parent.horizontalCenter
            y: mascotRoot.dogState === "sleeping" ? 24 : (mascotRoot.dogState === "lying" ? 19 :
               (mascotRoot.dogState === "sitting" ? 14 : 6))
            Behavior on y { NumberAnimation { duration: 280; easing.type: Easing.OutBack } }
        }

        Rectangle {
            id: barkTextBubble
            visible: false; width: 60; height: 30; radius: 15; color: "#FFFFFF"; border.color: "#3584E4"; border.width: 1.5
            anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 0
            Text { anchors.centerIn: parent; text: "Gâu! 🐾"; font.bold: true; font.pixelSize: 12; color: "#2C3E50" }
        }

        SleepDreamBubbleFlow {
            active: mascotRoot.dogState === "sleeping"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top; anchors.topMargin: -28
        }
    }
}
