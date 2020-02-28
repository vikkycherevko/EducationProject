({
    closeModel: function(component, event, helper) {
        component.set('v.isBasketOpen', false);
    },

    buyAll: function(component, event, helper) {
        let productInBasket = component.get("v.productInCurrentBasket");
        let basketContent = component.get("v.currentBasketContent");

        console.log('       productInBasket = '  + JSON.stringify(productInBasket));
        console.log('           basketContent=' + JSON.stringify(basketContent));
        console.log();
        var action = component.get("c.recalculateQuantity");
        action.setParams({
            "prodInBasket": JSON.stringify(productInBasket),
            "basketContent": JSON.stringify(basketContent)
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                let result = response.getReturnValue();
                console.log(result);
                // console.log(JSON.parse(result));
                // component.set("v.isInBasket", false);
                component.set("v.basketContent", JSON.parse(result));
            } else if (state === "ERROR") {
                let errors = response.getError();
                console.log('errors : ' + errors);
            } else {
                console.log('not understandable status : ' + state);
            }
        });
        $A.enqueueAction(action);
    },

    recalculateBasketPrice: function(component, event,  helper) {
        console.log('recalculateBasketPrice');
        let basketContent = component.get('v.basketContent');
        var newContent = event.getParam("newBasketContent");
        console.log('newContent = ' + newContent)
        basketContent.totalPrice = JSON.parse(newContent).totalPrice;
        component.set('v.basketContent', basketContent);
    },
})