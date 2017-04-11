import QtQuick 2.5
import QtQuick.Controls 2.0
import "../../assets/contents/help.js" as HelpContent

ApplicationWindow {
    visible: true

    Flickable {
        id: flick

        clip: true
        boundsBehavior: Flickable.StopAtBounds

        contentWidth: width
        contentHeight: text.height

        anchors.fill: parent

        Text {
            id: text

            readonly property string style: '<style>
                    .title {
                        color: %1;
                        font-size: %6px;
                    }
                    .subtitle { color: %2; }
                    body {
                        margin-left: %3px;
                    }
                    p, .subtitle {
                        margin-left: %4px;
                        font-size: %5px;
                    }
            </style>'
            .arg("red")
            .arg("blue")
            .arg(15)
            .arg(10)
            .arg(25)
            .arg(35)

            width: parent.width - 7
            textFormat: Text.RichText
            wrapMode: TextEdit.WordWrap
            text: ''

            Component.onCompleted: {
                var content = ""

                for(var key in HelpContent.content) {
                    var section = HelpContent.content[key]

                    if(typeof section["title"] != "undefined")
                        content += '<p class="title"><b>%1</b></p>'.arg(section["title"])
                    if(typeof section["subtitle"] != "undefined")
                        content += '<p class="subtitle">%1</p>'.arg(section["subtitle"])
                    if(typeof section["content"] != "undefined")
                        content += "<p>%1</p>".arg(section["content"])
                }
                text.text += "%1<body>%2</body>".arg(text.style).arg(content)
            }
        }
    }

    Rectangle { //scrollbar
        y: flick.visibleArea.yPosition * flick.height
        // TODO
        width: 4
        height: flick.visibleArea.heightRatio * flick.height

        color: "red"

        anchors.right: parent.right
    }
}
