({
    handleKeyUp: function (component, event) {
        var isEnterKey = event.keyCode === 13;
        var queryTerm = component.find('enter-search').get('v.value');
        if (isEnterKey) {
            component.set('v.issearching', true);
            var refreshEvent = component.getEvent("refreshListView");
            refreshEvent.setParam("searchWord", queryTerm);
            refreshEvent.fire();
            setTimeout(function() {
                component.set('v.issearching', false);
            }, 2000);
            refreshEvent.fire();
        }
        // var refreshEvent = component.getEvent("refreshListView");
        // refreshEvent.setParam("searchWord", queryTerm);
        // refreshEvent.fire();
    },
    openBasketModal: function (component, event) {
        component.set('v.isBasketOpen', true);
        console.log(component.get('v.isBasketOpen'));
    }
})