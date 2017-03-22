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
    function handleDeleteRequest(variableIndetifier) {
        var object = manager.findVariable(variableIndetifier)

        object.destroy()
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
