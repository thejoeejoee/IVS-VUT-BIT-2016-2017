import QtQuick 2.0

/**
  Component which loads all fonts
  */
Item {
    // loading font
    FontLoader {
        source: "qrc:/assets/fonts/ABeeZee-Regular.otf"
    }

    FontLoader {
        source: "qrc:/assets/fonts/Roboto-Light.ttf"
    }

    FontLoader {
        source: "qrc:/assets/fonts/Roboto-Medium.ttf"
    }
}
