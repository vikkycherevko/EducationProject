/**
 * Created by vikto on 18.06.2019.
 */

({
    doInit : function (component, event, helper) {
        helper.getFieldsForFilter(component, event, helper);
    },

    handleChange: function (component, event) {
        let result = component.get('v.PickersForField');
        let selectedResMap = [];
        var refreshEvent = component.getEvent("refreshListView");
        refreshEvent.setParam("checkboxValues", JSON.stringify(result));
        refreshEvent.fire();
    }
})