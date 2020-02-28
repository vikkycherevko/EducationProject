public with sharing class ProductCardController {

    private final static String PRICE_BOOK_NAME = 'Shop Price Book';

    @AuraEnabled
    public static String deleteProductFromBasket(String basCont, Product2 productToDelete) {
        BasketContent basketContent;
        try {
            basketContent = (BasketContent) JSON.deserialize(basCont, BasketContent.class);
        } catch (Exception e) {
            throw new AuraHandledException('Unexpected input for BasketContent');
        }
        for (Integer i = 0; i < basketContent.productsInBaskets.size() ; i++) {
            if (basketContent.productsInBaskets[i].product.Id == productToDelete.Id) {
                basketContent.productsInBaskets.remove(i);
            }
        }
        List<OpportunityLineItem> olis = [SELECT Id FROM OpportunityLineItem WHERE Product2Id = :productToDelete.Id];
        System.debug(' * INFO : olis : ' + olis);
        delete olis;
        return JSON.serialize(basketContent);
    }

     @AuraEnabled
     public static String buyAll(String basCont) {
         BasketContent basketContent;
         try {
             basketContent = (BasketContent) JSON.deserialize(basCont, BasketContent.class);
         } catch (Exception e) {
             throw new AuraHandledException('Unexpected input for BasketContent');
         }
         Opportunity opp = basketContent.currentOpportunity;
         opp.StageName = 'Paid';
         update opp;
         System.debug(' * INFO : opp : ' + opp);
         List<Product2> products = new List<Product2>();
         for (ProductInBasket pib : basketContent.productsInBaskets) {
             products.add(pib.product);
         }

         for (Product2 pr : products) {
             pr.IsActive = false;
         }
         update products;

         basketContent = null;
         return JSON.serialize(basketContent);
     }

    @AuraEnabled
    public static String recalculateQuantity(String prodInBasket, String basCont) {
        ProductInBasket productInBasket;
        BasketContent basketContent;
        System.debug(' * INFO : productInBasket : ' + prodInBasket);
        System.debug(' * INFO : basCont : ' + basCont);
        try {
            productInBasket = (ProductInBasket) JSON.deserialize(prodInBasket, ProductInBasket.class);
        } catch (Exception e) {
            throw new AuraHandledException('Unexpected input for BasketContent');
        }
        try {
            basketContent = (BasketContent) JSON.deserialize(basCont, BasketContent.class);
        } catch (Exception e) {
            throw new AuraHandledException('Unexpected input for BasketContent');
        }
        OpportunityLineItem oli = [
                SELECT Id
                        , Quantity
                FROM OpportunityLineItem
                WHERE Id = :productInBasket.opportunityLineItem.Id
        ];
        oli.Quantity = productInBasket.opportunityLineItem.Quantity;
        update oli;
        for (ProductInBasket pib : basketContent.productsInBaskets) {
            if (pib.opportunityLineItem.Id == productInBasket.opportunityLineItem.Id) {
                pib.opportunityLineItem.Quantity = oli.Quantity;
            }
        }
        basketContent.recalculateTotalPrice();

        return JSON.serialize(productInBasket);
    }

    @AuraEnabled
    public static String addProductToUserBasket(String basCont, Product2 product, Integer quantity, Integer price) {
        BasketContent basketContent;
        try {
            basketContent = (BasketContent) JSON.deserialize(basCont, BasketContent.class);
        } catch (Exception e) {
            throw new AuraHandledException('Unexpected input for BasketContent');
        }
        Opportunity opp;
        System.debug(' * INFO : product : ' + product);
        System.debug(' * INFO : price : ' + price);
        if (basketContent == null) {

            User currentUser = [SELECT Id, LastName FROM User WHERE Id =: UserInfo.getUserId()];

            List<Opportunity> opps = [
                    SELECT Id
                    FROM Opportunity
                    WHERE StageName = 'New'
                    AND OwnerId = :currentUser.Id
            ];
            if(opps == null || opps.size() == 0) {
                opp = new Opportunity();
                opp.Name = 'Basket for user: ' + currentUser.LastName;
                opp.StageName = 'New';
                opp.CloseDate = Date.today() + 1;
                opp.OwnerId = UserInfo.getUserId();
                insert opp;
            }
            opp = [
                    SELECT Id, Pricebook2Id
                    FROM Opportunity
                    WHERE StageName = 'New'
                    AND OwnerId = :UserInfo.getUserId()
                    LIMIT 1
            ];
            System.debug(opp.Pricebook2Id);
            basketContent = new BasketContent(opp);
            System.debug('basketContent = ' + basketContent);
        } else {
            opp = basketContent.currentOpportunity;
        }

        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Product2Id = product.Id;
        oli.OpportunityId = opp.Id;
        oli.Quantity = quantity;
        oli.TotalPrice = price;
        insert oli;

        basketContent.addProduct(new ProductInBasket(oli, product));
        System.debug('basketContent = ' + JSON.serializePretty(basketContent));
        return JSON.serialize(basketContent);
    }

    public class BasketContent {

        @AuraEnabled
        public Decimal totalPrice {
            get {
                if (totalPrice == null) {
                    totalPrice = 0;
                }
                return totalPrice;
            }
            set;
        }
        @AuraEnabled
        public Opportunity currentOpportunity {get; set; }

        @AuraEnabled
        public List<ProductInBasket> productsInBaskets{get; set; }

        public BasketContent(Opportunity currentOpportunity) {
            this.currentOpportunity = currentOpportunity;
            this.productsInBaskets = new List<ProductInBasket>();
        }

        public void addProduct(ProductInBasket pib) {
            this.productsInBaskets.add(pib);
            this.totalPrice += pib.opportunityLineItem.TotalPrice *  pib.opportunityLineItem.Quantity;
        }

        public void recalculateTotalPrice() {
            this.totalPrice = 0;
            for (ProductInBasket pib : productsInBaskets) {
                System.debug(' * INFO : pib : ' + pib);
                this.totalPrice += pib.opportunityLineItem.Quantity * pib.opportunityLineItem.TotalPrice;
            }
            System.debug(' * INFO : totalPrice : ' + totalPrice);
        }
    }
    public class ProductInBasket {
        @AuraEnabled
        public String currencyIsoCode {get; set; }

        @AuraEnabled
        public OpportunityLineItem opportunityLineItem {get; set; }

        @AuraEnabled
        public Product2 product {get; set; }

        public ProductInBasket(OpportunityLineItem opportunityLineItem, Product2 product) {
            this.opportunityLineItem = opportunityLineItem;
            this.product = product;
        }
    }
}