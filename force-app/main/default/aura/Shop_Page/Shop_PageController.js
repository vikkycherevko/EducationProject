/**
 * Created by vikto on 18.06.2019.
 */

({
    doInit: function(component, event, helper) {
        // this function call on the component load first time
        // get the page Number if it's not define, take 1 as default
        let page = component.get("v.page") || 1;
        // get the select option (drop-down) values.
        let recordToDisplay = component.find("recordSize").get("v.value");
        // call the helper function
        console.log('get rec');
        helper.getRecords(component, page, recordToDisplay, null, null);


        // helper.getTestPBS(component, event, helper);
    },

    navigate: function(component, event, helper) {
        // this function call on click on the previous page button
        let page = component.get("v.page") || 1;
        // get the previous button label
        let direction = event.getSource().get("v.label");
        // get the select option (drop-down) values.
        let recordToDisply = component.find("recordSize").get("v.value");
        // set the current page,(using ternary operator.)
        page = direction === "Previous Page" ? (page - 1) : (page + 1);
        // call the helper function
        helper.getRecords(component, page, recordToDisply, null, null);

    },

    onSelectChange: function(component, event, helper) {
        // this function call on the select opetion change,
        let page = 1
        let recordToDisply = component.find("recordSize").get("v.value");
        helper.getRecords(component, page, recordToDisply, null, null);
    },

    refreshListView: function(component, event, helper) {
        let checkboxValues = event.getParam("checkboxValues");
        console.log(checkboxValues);
        let searchWord = event.getParam("searchWord");
        console.log('chec '+searchWord);
        console.log('chec '+checkboxValues );
        helper.getRecords(component, 1, component.find("recordSize").get("v.value"), checkboxValues, searchWord);
    },

    getPBE: function(component, page, recordToDisplay, checkboxValues, searchWord) {
        this.showSpinner(component);
        // create a server side action.
        var action = component.get("c.fetchProducts");
        // set the parameters to method
        action.setParams({
            "pageNumber": page,
            "recordToDisplay": recordToDisplay,
            "checkboxValues": checkboxValues,
            "searchWord": searchWord
        });
        // set a call back
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
  
})