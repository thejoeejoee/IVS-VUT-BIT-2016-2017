import QtQuick 2.0

QtObject {
    id: manager

    signal newItem(var object)
    signal deleteItem(string identifier)
    signal setItem(string identifier, real value)

    property var itemComponent
    property Item componentsParent
    property var _variableItems: []

    function registerVariable(variableItem) {
        manager._variableItems.push(variableItem)
    }

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

    function setVariable(identifier, expression, value) {
        var variable = manager.findVariable(identifier)
        if(variable == null) {
            console.log("Error: variable not found")
            return
        }

        variable.variableExpression = expression
        variable.variableValue = value
    }

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

    function handleDeleteRequest(variableIndetifier) {
        var object = manager.findVariable(variableIndetifier)

        object.destroy()
        manager.deleteItem(variableIndetifier)
    }

    function handleSetRequest(variableIndetifier, value) {
        var object = manager.findVariable(variableIndetifier)

        object.variableValue = value
        object.variableExpression = value

        manager.setItem(variableIndetifier, value)
    }
}
