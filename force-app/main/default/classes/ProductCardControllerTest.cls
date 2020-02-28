@IsTest
public with sharing class ProductCardControllerTest {
    @IsTest
    private static void addProductToBasketTest() {
        Product2 workingProduct = getTestProduct();
        System.debug(workingProduct);
        List<OpportunityLineItem> oplis = ProductCardController.addProductToBasket(workingProduct, 2);
        List<Opportunity> opp = [SELECT Id FROM Opportunity];
        System.assertEquals(1, opp.size());
        System.assertEquals(1,  [SELECT Id FROM OpportunityLineItem WHERE OpportunityId = : opp[0].Id].size());
    }

    private static Product2 getTestProduct() {
        Product2 pr = new Product2(Name = 'Test Product');
        insert pr;
        return pr;
    }
}