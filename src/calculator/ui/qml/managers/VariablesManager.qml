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

/**
  Manager of dynamic manipulation with Variable items
  */
QtObject {
    id: manager

    /**
      Emit after creation of new object
      @param object Reference to new object
      */
    signal newItem(var object)
    /**
      Emit after deletion of new object
      @param identifier Identifier of deleted variable
      */
    signal deleteItem(string identifier)
    /**
      Emit after variable set, so other system could synchronize
      @param identifer Identifier of variable
      @param value New value of variable
      */
    signal setItem(string identifier, real value)

    /// Component from which objects will be created
    property var itemComponent
    /// Parent of new objects
    property Item componentsParent
    /// List of existing objects
    property var _variableItems: []

    /**
      Register item in system
      @param variableItem Item to be registered
      */
    function registerVariable(variableItem) {
        manager._variableItems.push(variableItem)
    }

    /**
      Create and register new variable item according to data
      @param identifier Identifier of variable
      @param expression Expression of variable
      @param value Value of variable
      */
    function addVariable(identifier, expression, value) {
        var object = manager.itemComponent.createObject(manager.componentsParent, {
                                    "variableIdentifier": identifier,
                                    "variableExpression": expression,
                                    "variableValue": value,
                                   })

        object.valueSetRequest.connect(manager.handleSetRequest)
        object.deleteRequest.connect(manager.handleDeleteRequest)
        manager.registerVariable(object)
        manager.newItem(object)
    }

    /**
      Sets value or expression to variable item
      @param identifier Identifier of variable
      @param expression New expression of variable
      @param value New value of variable
      */
    function setVariable(identifier, expression, value) {
        var variable = manager.findVariable(identifier)
        if(variable == null) {
            console.log("Error: variable not found")
            return
        }

        variable.variableExpression = expression
        variable.variableValue = value
    }

    /**
      Unregister variable item from manager
      @param variableIdentifier Identifier of variable
      */
    function _unregisterVariable(variableIdentifier) {
        for(var key in manager._variableItems) {

            if(manager._variableItems[key].variableIdentifier == variableIdentifier){
                manager._variableItems.splice(key, 1);
            }
        }
    }

    /**
      Finds variable item in system
      @param variableIdentifier Identifier of variable
      @return Item if is found else return null
      */
    function findVariable(variableIndetifier) {
        var object

        for(var key in manager._variableItems) {
            object = manager._variableItems[key]

            if(object.variableIdentifier == variableIndetifier){
                return object
            }
        }

        return null
    }

    /**
      Delete variable item
      @param variableIdentifier Identifier of variable
      */
    function deleteVariable(variableIdentifier) {
        var object = findVariable(variableIdentifier)
        _unregisterVariable(variableIdentifier)
        object.deleteItem()
    }

    /**
      Request deletion of variable item
      @param variableIdentifier Identifier of variable
      */
    function handleDeleteRequest(variableIndetifier) {
        var object = manager.findVariable(variableIndetifier)

        manager.deleteItem(variableIndetifier)
    }

    /**
      Sets value or expression to variable item and emit change
      @param identifier Identifier of variable
      @param expression New expression of variable
      @param value New value of variable
      */
    function handleSetRequest(variableIndetifier, value) {
        var object = manager.findVariable(variableIndetifier)

        object.variableValue = value
        object.variableExpression = value

        manager.setItem(variableIndetifier, value)
    }
}
