import QtQuick 2.0
import QtQuick.Particles 2.0

Item {
    clip: false

    ParticleSystem {
        id: rainbowParticleSystem
    }

    Column {
        anchors.top: parent.top
        anchors.left: parent.left

        Repeater {
            model: ["#ED1E24", "#F68F1E", "#F9ED24", "#34B44A", "#2F7CC0", "#765DA7"]
            delegate: ParticleGenerator {
                width: 15
                height: width

                groupName: modelData
                particleParent: root
                particleSystem: rainbowParticleSystem

                emitter.lifeSpan: 750
                emitter.emitRate: 40

                particle: Rectangle {
                    color: modelData
                    width: 15
                    height: width
                }
            }
        }
    }
}
