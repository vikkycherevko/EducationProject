public with sharing class ProductHandler {

    public static void addToAmountOfProducts(List<Shop_Stock_Item__c> triggerShopStockItems) {
        for (Shop_Stock_Item__c shopStockItem : triggerShopStockItems) {
            if (shopStockItem.Quantity__c < 3) {
                shopStockItem.Quantity__c = shopStockItem.Quantity__c + 5;
            }
        }
    }
}