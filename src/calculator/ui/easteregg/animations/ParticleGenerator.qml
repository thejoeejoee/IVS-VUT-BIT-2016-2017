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
        rotation: emitter.rotation
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
    }

    ItemParticle {
        parent: component.particleParent
        groups: [group.name]
        delegate: component.particle

        system: component.particleSystem
    }
}
