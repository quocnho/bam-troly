import QtQuick

Item {
    id: tagRoot
    property string dogState: "active"
    property real chestPuff: 1.0; property real bodyBob: 0
    property real springTagAngle: 0
    readonly property bool isLying: dogState === "lying" || dogState === "sleeping"
    readonly property bool isSitting: dogState === "sitting"

    // Vòng cổ ôm trọn bờ ngực trên
    width: isLying ? 36 : (isSitting ? 32 : 30)
    height: isLying ? 16 : 17

    // 1. Vòng cổ da thời trang đỏ bọc chỉ may
    Rectangle {
        id: collarStrap
        width: parent.width; height: isLying ? 4 : 4.5; radius: height / 2
        color: "#C0392B"; border.color: "#78281F"; border.width: 0.8
        anchors.horizontalCenter: parent.horizontalCenter; anchors.top: parent.top
        Rectangle {
            anchors.centerIn: parent; width: parent.width * 0.88; height: 1
            radius: 0.5; color: "#E6B0AA"; opacity: 0.6
        }
    }

    // 2. Thẻ tên BAM mở rộng chiều ngang, viền cyan thoáng đãng, sắc nét
    Rectangle {
        id: nameBadge
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: collarStrap.bottom
        width: isLying ? 27 : (isSitting ? 25 : 24)
        height: isLying ? 13 : 14.5
        radius: height / 2
        color: "#0B1329"
        border.color: "#38BDF8"; border.width: 1.25

        // Vòng đệm viền trong mờ tăng độ tương phản và chiều sâu công nghệ
        Rectangle {
            anchors.fill: parent; anchors.margins: 1.2; radius: parent.radius - 1.2
            color: "transparent"; border.color: "#0284C7"; border.width: 0.8; opacity: 0.4
        }
        // Vệt sáng bóng kim loại mượt mà phía trên
        Rectangle {
            anchors.top: parent.top; anchors.topMargin: 1; anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.7; height: 1.5; radius: 0.75; color: "#FFFFFF"; opacity: 0.45
        }

        // Chữ BAM chi tiết, giãn cách thoáng (tracking), sắc sảo nổi bật
        Text {
            anchors.centerIn: parent
            text: "BAM"
            font.bold: true
            font.pixelSize: tagRoot.isLying ? 7.6 : 8.6
            font.letterSpacing: 1.1
            font.family: "Monospace"
            color: "#FFFFFF"
        }

        rotation: (tagRoot.isLying ? -2.5 : (Math.sin(tagRoot.bodyBob * 1.5) * 3.5)) + tagRoot.springTagAngle
        Behavior on rotation { NumberAnimation { duration: 180; easing.type: Easing.OutSine } }
        Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }
        Behavior on height { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }
    }
}
