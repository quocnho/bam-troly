import QtQuick

Item {
    id: tailRoot
    property string dogState: "active"
    property bool isBarking: false
    property real tailWag: 0; property real curlFlex: 0
    property real springAngle: 0
    width: 22; height: 28

    // Đuôi vểnh cao tự nhiên, gọn gàng
    property real tailBaseAngle: tailRoot.dogState === "sleeping" ? -45 :
                                 (tailRoot.dogState === "lying" ? -36 :
                                 (tailRoot.dogState === "sitting" ? -18 : -28))

    SequentialAnimation {
        running: tailRoot.dogState !== "sleeping"
        loops: Animation.Infinite
        ParallelAnimation {
            NumberAnimation { target: tailRoot; property: "tailWag"; to: tailRoot.isBarking ? 40 : 28; duration: tailRoot.isBarking ? 80 : 130; easing.type: Easing.InOutSine }
            NumberAnimation { target: tailRoot; property: "curlFlex"; to: 16; duration: 120; easing.type: Easing.InOutQuad }
        }
        ParallelAnimation {
            NumberAnimation { target: tailRoot; property: "tailWag"; to: tailRoot.isBarking ? -40 : -28; duration: tailRoot.isBarking ? 80 : 130; easing.type: Easing.InOutSine }
            NumberAnimation { target: tailRoot; property: "curlFlex"; to: -16; duration: 120; easing.type: Easing.InOutQuad }
        }
    }

    Timer {
        interval: Math.floor(Math.random() * 2000) + 3000
        running: tailRoot.dogState === "sleeping"; repeat: true
        onTriggered: {
            sleepingFlickAnim.restart();
            interval = Math.floor(Math.random() * 2000) + 3000;
        }
    }
    SequentialAnimation {
        id: sleepingFlickAnim
        NumberAnimation { target: tailRoot; property: "tailWag"; to: 15; duration: 90; easing.type: Easing.OutQuad }
        NumberAnimation { target: tailRoot; property: "tailWag"; to: -6; duration: 80; easing.type: Easing.InOutQuad }
        NumberAnimation { target: tailRoot; property: "tailWag"; to: 0; duration: 110; easing.type: Easing.OutQuad }
    }

    Item {
        anchors.bottom: parent.bottom; anchors.right: parent.right
        width: 13; height: 24
        transformOrigin: Item.BottomRight
        rotation: tailRoot.tailBaseAngle + tailRoot.tailWag + tailRoot.springAngle

        // Thân đuôi nhỏ nhắn hơn, thuôn gọn
        Rectangle {
            width: 8.5; height: 18; radius: 4.25; color: "#CC5200"
            border.color: "#8A3300"; border.width: 1
            anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
            Rectangle {
                width: 2.5; height: 13; radius: 1.25; color: "#E67E22"; opacity: 0.6
                anchors.left: parent.left; anchors.leftMargin: 1; y: 2
            }
        }
        // Chóp đuôi trắng nhỏ nhắn xinh xắn
        Rectangle {
            width: 11.5; height: 11.5; radius: 5.75; color: "#FFFFFF"
            border.color: "#D5D8DC"; border.width: 1
            anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter
            rotation: tailRoot.curlFlex
        }
    }
}
