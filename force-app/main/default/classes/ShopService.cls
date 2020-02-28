/**
 * Created by vikto on 17.06.2019.
 */
public with sharing class ShopService {

    private static final String FIELD_SET_NAME = 'Fields_For_Filter';
    private static final String WORKING_PRODUCT_NAME = 'Product2';
    // I know it bad(((
    public static List<Product2> allProducts {
        get {
            if (allProducts == null) {
                String basickQuery = 'SELECT Id, Name, Image__c ' + getFieldsString()
                        +'   FROM Product2 ORDER BY Name ';
                System.debug(' * INFO : basickQuery : ' + basickQuery);
                allProducts = Database.query(basickQuery);
            }
            return allProducts;
        }
        set;
    }

    public static List<Schema.FieldSetMember> getFieldsFromFieldSet() {
        List<Schema.FieldSetMember> fields = new List<Schema.FieldSetMember>();
        Schema.DescribeSObjectResult productDescribe = Product2.sObjectType.getDescribe();
        Schema.FieldSet currentFieldSet = productDescribe.FieldSets.getMap().get(FIELD_SET_NAME);
        for (Schema.FieldSetMember fs : currentFieldSet.getFields()) {
            fields.add(fs);
        }
        System.debug(' * INFO : fields : ' + fields);
        return fields;
    }
    public static String getFieldsString() {
        String result = '';
       for (Schema.FieldSetMember fsm : getFieldsFromFieldSet()) {
           result+= ', ' + fsm.getFieldPath();
       }
        return result;
    }

}