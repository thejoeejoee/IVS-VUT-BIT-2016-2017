import QtQuick 2.0
import QtQuick.Particles 2.0

Item {
    id: component

    property alias emitter: emitter
    property string groupName

    property Item particleParent
    property Item particleSystem
    property Component particle: Rectangle {
        width: component.width
        height: width
        color: "black"
    }

    ParticleGroup {
        id: group
        name: component.groupName
    }

    Emitter {
        id: emitter

        group: group.name
        system: component.particleSystem

        emitRate: component.emitRate
        lifeSpan: component.lifeSpan
        lifeSpanVariation: 200
        size: 16
        endSize: 32

        anchors.fill: component

        velocity: AngleDirection {
            angle: 180
            magnitude: 300
        }

        acceleration: AngleDirection {
            angle: 180
            magnitude: 300
        }
    }

    ItemParticle {
        parent: component.particleParent
        groups: [group.name]
        delegate: component.particle

        system: component.particleSystem
    }
}
