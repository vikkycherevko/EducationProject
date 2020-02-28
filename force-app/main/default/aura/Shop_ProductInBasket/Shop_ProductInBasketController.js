({
    changeProductQuantity: function(component, event, helper) {
        let basketContent = component.get("v.currentBasketContent");
        let prodInBasket = component.get("v.productInCurrentBasket");
        console.log('           productInCurrentBasket=' + JSON.stringify(prodInBasket));
        console.log('           basketContent=' + JSON.stringify(basketContent));
        var action = component.get("c.recalculateQuantity");
        action.setParams({
            "prodInBasket": JSON.stringify(prodInBasket),
            "basCont": JSON.stringify(basketContent)

        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                let result = response.getReturnValue();
                // component.set("v.currentBasketContent", JSON.parse(result));
                // console.log(JSON.parse(result));
                //recalculateBasketPrice
                // let recalcEvent = component.getEvent("recalculateBasketPrice");
                // recalcEvent.setParams({ "newBasketContent": result });
                // console.log('result  result result  ' + result);
                // recalcEvent.fire();
                // console.log(result);
                // console.log(JSON.parse(result));
                // component.set("v.isInBasket", false);
            } else if (state === "ERROR") {
                let errors = response.getError();
                console.log('errors : ' + errors);
            } else {
                console.log('not understandable status : ' + state);
            }
        });
        $A.enqueueAction(action);
    },
    deleteFromBasket: function(component, event, helper) {
        console.log('---------------------------------');
        let productInBasket = component.get("v.productInCurrentBasket.product.Id");
        console.log(JSON.parse(productInBasket));
        console.log('---------------------------------');

        // var action = component.get("c.deleteProductFromBasket");
        // action.setParams({
        //     "basCont": JSON.stringify(basketContent),
        //     "productToDelete": productInBasket.product
        // });
        // action.setCallback(this, function (response) {
        //     var state = response.getState();
        //     if (state == 'SUCCESS') {
        //         let result = response.getReturnValue();
        //         console.log(result);
        //         console.log(JSON.parse(result));
        //         component.set("v.isInBasket", false);
        //         component.set("v.basketContent", JSON.parse(result));
        //     } else if (state === "ERROR") {
        //         let errors = response.getError();
        //         console.log('errors : ' + errors);
        //     } else {
        //         console.log('not understandable status : ' + state);
        //     }
        // });
        // $A.enqueueAction(action);
    }
})