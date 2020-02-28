public with sharing class ProductListController {

    @AuraEnabled
    public static String getProducts() {
        System.debug('getProducts');
        return JSON.serialize([
                SELECT Id
                        , Name
                        , Image__c
                FROM Product2
                LIMIT 2000
        ]);

    }

    @AuraEnabled
    public static ProductPageWrapper fetchProducts(Decimal pageNumber ,Integer recordToDisplay) {
        Integer pageSize = recordToDisplay;
        Integer offset = ((Integer)pageNumber - 1) * pageSize;

        // create a instance of wrapper class.
        ProductPageWrapper obj =  new ProductPageWrapper();
        // set the pageSize,Page(Number), total records and accounts List(using OFFSET)
        obj.pageSize = pageSize;
        obj.page = (Integer) pageNumber;
        obj.total = [SELECT count() FROM Product2];
        obj.products = [
                SELECT Id
                        , Name
                        , Image__c
                FROM Product2
                ORDER BY Name
                LIMIT :recordToDisplay

                OFFSET :offset
        ];
        System.debug(obj.products);
        // return the wrapper class instance .
        return obj;
    }

    // create a wrapper class with @AuraEnabled Properties
    public class ProductPageWrapper {
        @AuraEnabled public Integer pageSize {get;set;}
        @AuraEnabled public Integer page {get;set;}
        @AuraEnabled public Integer total {get;set;}
        @AuraEnabled public List<Product2> products {get;set;}
    }
}