({
    getFieldsForFilter: function (component, event, helper) {
        var action = component.get("c.getFieldsForFilter");
        action.setCallback(this, function (response) {
                var state = response.getState();
                if (state == 'SUCCESS') {
                    let result = JSON.parse(response.getReturnValue());

                    result.forEach(function (field) {
                        field.options = [];
                        field.chosedItems = [];
                        for (var j = 0; j < field.pickListValues.length; j++) {
                            field.options.push({
                                class: "optionClass",
                                label: field.pickListValues[j].label + ' (' +field.pickListValues[j].amount+ ') ',
                                value: field.pickListValues[j].value
                            });
                        }
                    });
                    component.set('v.PickersForField', result);
                } else if (state === "ERROR") {
                    let errors = response.getError();
                    this.handleErrors(errors);
                } else {
                    console.log('not understandable status : ' + state);
                }
            }
        );
        $A.enqueueAction(action);
    },

    handleErrors : function(errors) {
        // Configure error toast
        let toastParams = {
            title: "Error",
            message: "Unknown error", // Default error message
            type: "error"
        };
        // Pass the error message if any
        if (errors && Array.isArray(errors) && errors.length > 0) {
            toastParams.message = errors[0].message;
        }
        // Fire error toast
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    }
})