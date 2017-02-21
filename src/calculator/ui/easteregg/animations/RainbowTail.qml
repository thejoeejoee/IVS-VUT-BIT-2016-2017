import QtQuick 2.0
import QtQuick.Particles 2.0

Item {
    id: rainbowTail

    property real generationAngle: 0
    property size particleSize: Qt.size(10, 10)
    property Item rootItem
    property Item containerItem

    clip: false

    ParticleSystem {
        id: rainbowParticleSystem
        parent: rainbowTail.rootItem
    }

    Column {
        Repeater {
            id: repeater

            model: ["#ED1E24", "#F68F1E", "#F9ED24", "#34B44A", "#2F7CC0", "#765DA7"]
            delegate: Item {
                id: substitute

                width: height
                height: (rainbowTail.height / 6)

                Component.onCompleted: singleColorGenerator.setPos()

                ParticleGenerator {
                    id: singleColorGenerator

                    width: height
                    height: (rainbowTail.height / 6)

                    parent: rainbowTail.containerItem

                    rotation: rainbowTail.rotation
                    groupName: modelData
                    particleParent: rainbowTail.rootItem
                    particleSystem: rainbowParticleSystem

                    emitter.lifeSpan: 350
                    emitter.emitRate: 50
                    emitter.velocity: AngleDirection {
                        angle: rainbowTail.generationAngle
                        magnitude: 100
                    }
                    emitter.acceleration: AngleDirection {
                        angle: rainbowTail.generationAngle
                        magnitude: 100
                    }


                    particle: Rectangle {
                        color: modelData
                        width: rainbowTail.particleSize.width
                        height: rainbowTail.particleSize.height
                    }

                    Component.onCompleted: {
                        rainbowTail.rotationChanged.connect(singleColorGenerator.setPos)
                        singleColorGenerator.setPos()
                    }

                    function setPos() {
                        var newPos = rainbowTail.containerItem.mapFromItem(substitute, 0, 0)

                        singleColorGenerator.x = newPos.x
                        singleColorGenerator.y = newPos.y
                    }

                }
            }
        }
    }
}
