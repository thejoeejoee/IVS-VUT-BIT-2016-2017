QT += qml quick

CONFIG += c++11

SOURCES += main.cpp \
    types/sides.cpp

RESOURCES += ../../src/calculator/ui/qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    types/sides.h
