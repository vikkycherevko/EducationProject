({
    doInit: function (component, event, helper) {
        let sms = component.get('v.product');

    },

    deleteFromBasket: function (component, event, helper) {
        let product = component.get("v.product");
        let basketContent = component.get("v.basketContent");

        var action = component.get("c.deleteProductFromBasket");
        action.setParams({
            "basCont": JSON.stringify(basketContent),
            "productToDelete": product
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                let result = response.getReturnValue();
                console.log(result);
                console.log(JSON.parse(result));
                component.set("v.isInBasket", false);
                component.set("v.basketContent", JSON.parse(result));
            } else if (state === "ERROR") {
                let errors = response.getError();
                console.log('errors : ' + errors);
            } else {
                console.log('not understandable status : ' + state);
            }
        });
        $A.enqueueAction(action);
    }
    , addProductToBasket: function (component, event, helper) {
        let self = this;
        let product = component.get("v.product");
        console.log(product.PricebookEntries[0].UnitPrice);
        var action = component.get("c.addProductToUserBasket");
        action.setParams({
            "basCont": JSON.stringify(component.get("v.basketContent")),
            "product": product,
            "quantity": 1,
            "price": product.PricebookEntries[0].UnitPrice
        });
        // set a call back
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                let result = response.getReturnValue();
                console.log(result);
                console.log(JSON.parse(result));
                component.set("v.isInBasket", true);
                component.set("v.basketContent", JSON.parse(result));
            } else if (state === "ERROR") {
                let errors = response.getError();
                console.log('errors : ' + errors);

                // this.handleErrors(errors);
            } else {
                console.log('not understandable status : ' + state);
            }
        });
        $A.enqueueAction(action);
        
    }
})