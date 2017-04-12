import QtQuick 2.0
import QtQuick.Particles 2.0

/**
  Component which generates particles
  */
Item {
    id: component

    /// Expose emitter component
    property alias emitter: emitter
    /// String name to identify group of particles which are the same
    property string groupName

    /// Parent of particles, determinates particle coord system and visibility
    property Item particleParent
    /// Stores reference to global particle system
    property Item particleSystem
    /// Property which store component of particle, which will be delegated
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
