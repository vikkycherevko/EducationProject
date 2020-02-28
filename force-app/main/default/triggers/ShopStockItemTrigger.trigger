trigger ShopStockItemTrigger on Shop_Stock_Item__c (before update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        ProductHandler.addToAmountOfProducts(Trigger.new);
    }
}