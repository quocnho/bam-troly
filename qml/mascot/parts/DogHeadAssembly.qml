import QtQuick
import "../parts"

Item {
    id: mascotHeadRoot
    property string dogState: "active"
    property bool isBarking: false
    property real headTiltAngle: 0
    property real gazeX: 0; property real gazeY: 0
    property bool isTrackingMouse: false
    property bool isAlert: false
    property bool isLicking: false
    property real earFlap: 0
    property real springAngleL: 0; property real springAngleR: 0
    width: 54; height: 46

    property real baseTiltAngle: mascotHeadRoot.dogState === "sitting" ? 8 :
                                  (mascotHeadRoot.dogState === "sleeping" ? -14 : 0)

    // Khối đầu xoay tổng thể (gắn liền cổ nâng đỡ chắc chắn)
    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom; anchors.bottomMargin: 2
        width: 44; height: 42
        transformOrigin: Item.Bottom
        rotation: mascotHeadRoot.baseTiltAngle + mascotHeadRoot.headTiltAngle
        Behavior on rotation { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }

        // Tai gắn trực tiếp sát đỉnh hộp sọ và nghiêng theo đầu
        DogEars {
            dogState: mascotHeadRoot.dogState
            isAlert: mascotHeadRoot.isAlert
            earFlap: mascotHeadRoot.earFlap
            springAngleL: mascotHeadRoot.springAngleL
            springAngleR: mascotHeadRoot.springAngleR
            anchors.horizontalCenter: parent.horizontalCenter
            y: -10; z: -1
        }

        // Hộp sọ đầu 3D
        Rectangle {
            id: skull
            anchors.fill: parent; radius: 20; color: "#F0B27A"
            border.color: "#B9770E"; border.width: 1.2

            Rectangle {
                anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.75; height: 4; radius: 2; color: "#A04000"; opacity: 0.35
            }
            // Đốm trắng trên trán mở rộng mềm mại, duyên dáng
            Rectangle {
                width: 7.5; height: 9.0; radius: 3.75; color: "#FFFFFF"
                anchors.horizontalCenter: parent.horizontalCenter; y: 4
            }
            DogEyes {
                dogState: mascotHeadRoot.dogState; isTrackingMouse: mascotHeadRoot.isTrackingMouse
                gazeX: mascotHeadRoot.gazeX; gazeY: mascotHeadRoot.gazeY
                anchors.horizontalCenter: parent.horizontalCenter; y: 11
            }
            DogMouth {
                dogState: mascotHeadRoot.dogState; isBarking: mascotHeadRoot.isBarking
                isLicking: mascotHeadRoot.isLicking
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom; anchors.bottomMargin: 1
            }
            Rectangle { width: 5; height: 3.5; radius: 2; color: "#F1948A"; opacity: 0.6; x: 3; y: 22 }
            Rectangle { width: 5; height: 3.5; radius: 2; color: "#F1948A"; opacity: 0.6; x: 34; y: 22 }
        }
    }
}
