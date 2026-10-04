import QtQuick

Item {
    id: torsoRoot
    property string dogState: "active"; property bool isBarking: false
    property real chestPuff: 1.0; property real squashY: 1.0; property real squashX: 1.0
    property real legStride: 0; property real legLiftLeft: 0; property real legLiftRight: 0
    property real springTailAngle: 0
    width: 80; height: 54

    SequentialAnimation {
        running: torsoRoot.dogState === "intro"; loops: Animation.Infinite
        NumberAnimation { target: torsoRoot; property: "legStride"; to: 6; duration: 120 }
        NumberAnimation { target: torsoRoot; property: "legStride"; to: -6; duration: 120 }
    }

    // 1. Chân sau (Hind legs - màu tối đậm tạo bóng khối chân thực)
    Row {
        anchors.horizontalCenter: torsoRect.horizontalCenter; anchors.bottom: torsoRect.bottom; anchors.bottomMargin: -2; z: -2
        spacing: torsoRoot.dogState === "lying" || torsoRoot.dogState === "sleeping" ? 34 : (torsoRoot.dogState === "sitting" ? 28 : 22)
        visible: torsoRoot.dogState !== "intro"
        Repeater {
            model: 2
            Rectangle {
                width: torsoRoot.dogState === "sitting" ? 12 : 9; radius: 4; color: "#A0522D"
                height: torsoRoot.dogState === "lying" || torsoRoot.dogState === "sleeping" ? 7 : (torsoRoot.dogState === "sitting" ? 14 : 10)
                border.color: "#783917"; border.width: 1
                Rectangle { width: parent.width * 0.8; height: 3; radius: 1.5; color: "#FAF0E6"; anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter }
            }
        }
    }

    // 2. Khớp đuôi
    DogTail {
        dogState: torsoRoot.dogState; isBarking: torsoRoot.isBarking; springAngle: torsoRoot.springTailAngle
        anchors.bottom: torsoRect.bottom; anchors.right: torsoRect.left; z: -1
        anchors.rightMargin: torsoRoot.dogState === "sleeping" ? -9 : -12
        anchors.bottomMargin: torsoRoot.dogState === "sleeping" ? 6 : (torsoRoot.dogState === "sitting" ? 8 : 12)
    }

    // 3. Thân mình với đốm ngực chuyển mờ tự nhiên in chữ BAM đen xám
    Rectangle {
        id: torsoRect
        width: (torsoRoot.dogState === "lying" || torsoRoot.dogState === "sleeping" ? 37 : (torsoRoot.dogState === "sitting" ? 44 : 40)) * torsoRoot.squashX
        height: (torsoRoot.dogState === "lying" || torsoRoot.dogState === "sleeping" ? 30 : (torsoRoot.dogState === "sitting" ? 34 : 38)) * torsoRoot.squashY
        radius: torsoRoot.dogState === "lying" || torsoRoot.dogState === "sleeping" ? 14 : 16
        color: "#E59866"; border.color: "#A04000"; border.width: 1.2
        anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: parent.bottom; anchors.bottomMargin: 4
        scale: torsoRoot.chestPuff

        Rectangle { anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter; width: parent.width * 0.9; height: 4; radius: 2; color: "#935116"; opacity: 0.35 }

        // Đốm trắng ở ngực với viền gradient mờ dần và chữ BAM đen xám
        Rectangle {
            id: chestBib; radius: width / 2; color: "#FFFFFF"; anchors.horizontalCenter: parent.horizontalCenter
            width: torsoRoot.dogState === "lying" || torsoRoot.dogState === "sleeping" ? 18 : 19
            height: parent.height * (torsoRoot.dogState === "lying" || torsoRoot.dogState === "sleeping" ? 0.46 : 0.68)
            anchors.bottom: parent.bottom; anchors.bottomMargin: 3
            Rectangle { anchors.fill: parent; anchors.margins: -1.8; z: -1; radius: parent.radius + 1.8; color: "#EFC8B1"; opacity: 0.55 }
            Rectangle { anchors.fill: parent; anchors.margins: -3.2; z: -2; radius: parent.radius + 3.2; color: "#EAB292"; opacity: 0.30 }

            Text {
                text: "BAM"; font.bold: true; font.letterSpacing: 1.0; font.family: "Monospace"
                font.pixelSize: torsoRoot.dogState === "lying" ? 6.5 : 8.0; color: "#94A3B8"; opacity: 0.45
                x: (parent.width - width) / 2 + 0.6; y: (parent.height - height) / 2 + 0.7
            }
            Text {
                anchors.centerIn: parent; text: "BAM"; font.bold: true; font.letterSpacing: 1.0
                font.family: "Monospace"; font.pixelSize: torsoRoot.dogState === "lying" ? 6.5 : 8.0; color: "#1E293B"
            }
        }
    }

    DogFrontPaws {
        dogState: torsoRoot.dogState
        legLiftLeft: torsoRoot.legLiftLeft; legLiftRight: torsoRoot.legLiftRight; legStride: torsoRoot.legStride
        anchors.horizontalCenter: torsoRect.horizontalCenter; anchors.bottom: parent.bottom; z: 1
    }
}
