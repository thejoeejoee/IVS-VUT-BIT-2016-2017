import QtQuick 2.0

QtObject {
    id: manager

    signal newItem(var object)

    property var itemComponent
    property Item componentsParent
    property var _variableItems: []

    function addVariable(identifier, expression, value) {
        var object = manager.itemComponent.createObject(manager.componentsParent, {
                                    "variableIdentifier": identifier,
                                    "variableExpression": expression,
                                    "variableValue": value,
                                   })

        object.valueSetRequest.connect(manager.handleSetRequest)
        object.deleteRequest.connect(manager.handleDeleteRequest)
        manager._variableItems.push(object)
        manager.newItem(object)
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

        // TODO call adapter delete
        object.destroy()
    }

    function handleSetRequest(variableIndetifier, value) {
        var object = manager.findVariable(variableIndetifier)

        object.variableValue = value
        object.variableExpression = value

        // TODO call adapter set
    }
}
