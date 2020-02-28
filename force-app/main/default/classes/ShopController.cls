/**
 * Created by vikto on 17.06.2019.
 */

public with sharing class ShopController {
    @AuraEnabled
    public static String getProducts() {
        System.debug('getProducts');
        return JSON.serialize([
                SELECT Id
                        , Name
                        , Brand__c
                        , Image__c
                        , (
                        SELECT Id
                                , UnitPrice
                                , Currency_Iso_Code__c
                        FROM PricebookEntries
                )
                FROM Product2
                LIMIT 2000
        ]);

    }

    @AuraEnabled
    public static ProductPageWrapper fetchProducts(Decimal pageNumber, Integer recordToDisplay, String checkboxValues, String searchWord) {
        Integer pageSize = recordToDisplay;
        Integer offset = ((Integer) pageNumber - 1) * pageSize;

        // create a instance of wrapper class.
        ProductPageWrapper obj = new ProductPageWrapper();
        // set the pageSize,Page(Number), total records and accounts List(using OFFSET)
        obj.pageSize = pageSize;
        obj.page = (Integer) pageNumber;
        obj.total = [SELECT count() FROM Product2];
        obj.products = selectProducts(offset, pageNumber, checkboxValues, searchWord, recordToDisplay);
        System.debug(obj.products);
        // return the wrapper class instance .
        return obj;
    }

    @AuraEnabled
    public static List<Product2> selectProducts(Integer offset
            , Decimal pageNumber
            , String pickerValues
            , String searchWord
            , Integer recordToDisplay

    ) {
        System.debug(' * INFO : pickerValues : ' + pickerValues);
        System.debug(' * INFO : searchWord : ' + searchWord);
        List<FilterCheckboxController.PickersForField> checkboxInfo;
        if (pickerValues != null) {
            checkboxInfo = (List<FilterCheckboxController.PickersForField>) JSON.deserialize(pickerValues,
                    List<FilterCheckboxController.PickersForField>.class);


            for (FilterCheckboxController.PickersForField pf : checkboxInfo) {
                System.debug(' * INFO : pf.chosedItems : ' + pf.chosedItems);
            }
        }

        List<Product2> result = new List<Product2>();
        String basicQuery = ' SELECT Id ' +
                '        , Name ' +
                '        , Image__c ' +
                '        , IsActive ' +
                ', ('+
                ' SELECT Id '+
                ', UnitPrice '+
                ', Currency_Iso_Code__c '+
                ' FROM PricebookEntries ) ';


        System.debug(' * INFO : FilterCheckboxController.getFieldsForFilter() : ' + FilterCheckboxController.getFieldsForFilter());
        for (FilterCheckboxController.PickersForField field : (List<FilterCheckboxController.PickersForField>) JSON.deserialize(FilterCheckboxController.getFieldsForFilter(), List<FilterCheckboxController.PickersForField>.class)) { // FilterCheckboxController
            basicQuery += ', ' + field.fieldAPIName;
        }


        basicQuery += ' FROM Product2 ';
        Boolean whereExist = false;
        Boolean andExist = false;
        Boolean addedSomeConditions = false;
        if (searchWord != null) {
            basicQuery += ' WHERE Name Like \'%' + searchWord + '%\'';
            whereExist = true;
        }

        if (checkboxInfo != null && checkboxInfo.size() > 0) {
            if (!whereExist) {
                basicQuery += ' WHERE ';
            }
            for (FilterCheckboxController.PickersForField pff : checkboxInfo) {
                if (pff.chosedItems.size() == 0) {
                    continue;
                }
                addedSomeConditions = true;
                if (andExist) {
                    basicQuery += ' AND ';
                }
                basicQuery += ' ( ';
                for (String value : pff.chosedItems) {
                    basicQuery += pff.fieldAPIName + ' = \'' + value + '\' OR ';
                }
                andExist = true;
                basicQuery = basicQuery.removeEnd(' OR ');
                basicQuery += ')';
            }
            if (!addedSomeConditions) {
                basicQuery = basicQuery.removeEnd(' WHERE ');
            }
//            whereExist = true;
        }


        basicQuery += ' ORDER BY Name ' +
                ' LIMIT :recordToDisplay ' +
                ' OFFSET :offset';

        System.debug(' * INFO : basicQuery : ' + basicQuery);
        result = Database.query(basicQuery);
        System.debug(' * INFO : basicQuery Result  : ' + result);
        return result;
    }

    @AuraEnabled
    public static List<OpportunityLineItem> getTestRecords() {
        System.debug('getTestRecords');
        List<OpportunityLineItem> pbes = [SELECT Id, Name FROM OpportunityLineItem];
        System.debug(' * INFO : pbes : ' + pbes);
        return pbes;
    }

    // create a wrapper class with @AuraEnabled Properties
    public class ProductPageWrapper {
        @AuraEnabled public Integer pageSize { get; set; }
        @AuraEnabled public Integer page { get; set; }
        @AuraEnabled public Integer total { get; set; }
        @AuraEnabled public List<Product2> products { get; set; }
    }
}