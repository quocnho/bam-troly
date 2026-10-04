import QtQuick
import "../behaviors"

Item {
    id: earsRoot
    property string dogState: "active"
    property real earTwitch: 0; property real earFlap: 0
    property bool isAlert: false
    property real randomTiltL: 0; property real randomTiltR: 0
    property real halfFoldL: 0; property real halfFoldR: 0
    property real springAngleL: 0; property real springAngleR: 0
    // Thu gọn chiều rộng để tai áp sát vào đầu hơn
    width: 48; height: 30

    DogEarBehavior { earsTarget: earsRoot; isSleeping: earsRoot.dogState === "sleeping" }

    component DogPlayfulEar: Item {
        width: 19; height: 26; property bool isLeft: true
        // Tai nằm ngang đều đặn 2 bên đầu (-26° / +26°)
        property real baseSplay: isLeft ? -26 : 26
        property real stateRot: earsRoot.dogState === "sleeping" ? (isLeft ? -42 : 42) :
                                (earsRoot.dogState === "lying" ? (isLeft ? -30 : 30) :
                                (earsRoot.isAlert ? (isLeft ? -8 : 8) : baseSplay))
        property real dynRot: isLeft ? earsRoot.randomTiltL : earsRoot.randomTiltR
        property real dynFold: isLeft ? earsRoot.halfFoldL : earsRoot.halfFoldR
        property real springRot: isLeft ? earsRoot.springAngleL : earsRoot.springAngleR

        transformOrigin: isLeft ? Item.BottomRight : Item.BottomLeft
        rotation: stateRot + dynRot + springRot + (isLeft ? (earsRoot.earTwitch + earsRoot.earFlap) : (-earsRoot.earTwitch * 0.7 - earsRoot.earFlap))
        Behavior on rotation { NumberAnimation { duration: 220; easing.type: Easing.OutBack } }

        Canvas {
            id: earCanvas; anchors.fill: parent
            property real foldFactor: dynFold
            onFoldFactorChanged: requestPaint()
            onPaint: {
                var ctx = getContext("2d"); ctx.reset();
                var w = width; var h = height;
                var foldY = dynFold * (h * 0.35);
                // Vành ngoài tai: uốn lượn mềm mại, gốc tai ôm sát hộp sọ
                ctx.beginPath();
                if (isLeft) {
                    ctx.moveTo(w, h); ctx.lineTo(1, h);
                    ctx.bezierCurveTo(0, h * 0.52, 1, 6 + foldY, w * 0.44, 1.8 + foldY);
                    ctx.bezierCurveTo(w * 0.76, 1.8 + foldY, w - 1, h * 0.44, w, h);
                } else {
                    ctx.moveTo(0, h); ctx.lineTo(w - 1, h);
                    ctx.bezierCurveTo(w, h * 0.52, w - 1, 6 + foldY, w * 0.56, 1.8 + foldY);
                    ctx.bezierCurveTo(w * 0.24, 1.8 + foldY, 1, h * 0.44, 0, h);
                }
                ctx.fillStyle = "#C66900"; ctx.fill();
                ctx.lineWidth = 1.25; ctx.strokeStyle = "#8A3B00"; ctx.stroke();

                // Lòng tai hồng phấn bo cong đồng bộ
                ctx.beginPath();
                if (isLeft) {
                    ctx.moveTo(w - 2.5, h - 2); ctx.lineTo(3, h - 2);
                    ctx.bezierCurveTo(2.5, h * 0.52, 3.5, 7 + foldY, w * 0.44, 5 + foldY);
                    ctx.bezierCurveTo(w * 0.72, 5 + foldY, w - 2.5, h * 0.48, w - 2.5, h - 2);
                } else {
                    ctx.moveTo(2.5, h - 2); ctx.lineTo(w - 3, h - 2);
                    ctx.bezierCurveTo(w - 2.5, h * 0.52, w - 3.5, 7 + foldY, w * 0.56, 5 + foldY);
                    ctx.bezierCurveTo(w * 0.28, 5 + foldY, 2.5, h * 0.48, 2.5, h - 2);
                }
                ctx.fillStyle = "#F5CBA7"; ctx.fill();
            }
        }
    }

    DogPlayfulEar { id: leftEar; isLeft: true; x: 2; y: 1 }
    DogPlayfulEar { id: rightEar; isLeft: false; x: 27; y: 1 }
}
