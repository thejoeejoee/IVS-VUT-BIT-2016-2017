/**************************************************************************
**   Calculator
**   Copyright (C) 2017 /dej/uran/dom team
**   Authors: Son Hai Nguyen
**   Credits: Josef Kolář, Son Hai Nguyen, Martin Omacht, Robert Navrátil
**
**   This program is free software: you can redistribute it and/or modify
**   it under the terms of the GNU General Public License as published by
**   the Free Software Foundation, either version 3 of the License, or
**   (at your option) any later version.
**
**   This program is distributed in the hope that it will be useful,
**   but WITHOUT ANY WARRANTY; without even the implied warranty of
**   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**   GNU General Public License for more details.
**
**   You should have received a copy of the GNU General Public License
**   along with this program.  If not, see <http://www.gnu.org/licenses/>.
**************************************************************************/
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
