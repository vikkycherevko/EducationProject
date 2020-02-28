/**
 * Created by vikto on 18.06.2019.
 */
({
    getRecords: function(component, page, recordToDisplay, checkboxValues, searchWord) {
        this.showSpinner(component);
        // create a server side action.
        var action = component.get("c.fetchProducts");
        // set the parameters to method
        console.log('get re');
        action.setParams({
            "pageNumber": page,
            "recordToDisplay": recordToDisplay,
            "checkboxValues": checkboxValues,
            "searchWord": searchWord
        });
        // set a call back
        console.log('get r');
        action.setCallback(this, function(a) {
            // store the response return value (wrapper class insatance)
            var result = a.getReturnValue();
            // set the component attributes value with wrapper class properties.
            component.set("v.products", result.products);
            component.set("v.page", result.page);
            component.set("v.total", result.total);
            component.set("v.pages", Math.ceil(result.total / recordToDisplay));
            this.hideSpinner(component);
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    showSpinner: function(component) {
        // make Spinner attribute true for display loading spinner
        component.set("v.Spinner", true);
    },


    // this function automatic call by aura:doneWaiting event
    hideSpinner : function(component){
        // make Spinner attribute to false for hide loading spinner
        component.set("v.Spinner", false);
    }
})