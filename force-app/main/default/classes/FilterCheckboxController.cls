/**
 * Created by vikto on 17.06.2019.
 */
public with sharing class FilterCheckboxController {


    private static final String FIELD_SET_NAME = 'Fields_For_Filter';
    private static final String WORKING_PRODUCT_NAME = 'Product2';

    @AuraEnabled
    public static String getFieldsForFilter() {
        List<PickersForField> allPickers = new List<PickersForField>();
        List<Schema.FieldSetMember> allFields = ShopService.getFieldsFromFieldSet();
        for (Schema.FieldSetMember field : allFields) {
            allPickers.add(new PickersForField(field));
        }
        System.debug(' * INFO : JSON.serialize(allPickers) : ' + JSON.serialize(allPickers));
        return JSON.serialize(allPickers); // do n t work with  ist<Schema.PicklistEntry>
    }

    public class PickersForField {

        @AuraEnabled
        public Boolean isDBRequired { get; set; }
        @AuraEnabled
        public Boolean isRequired { get; set; }
        @AuraEnabled
        public String fieldType { get; set; }
        @AuraEnabled
        public String fieldLabel { get; set; }
        @AuraEnabled
        public String fieldAPIName { get; set; }
        @AuraEnabled
        public List<PickersValues> pickListValues { get; set; }
        @AuraEnabled
        public List<String> chosedItems { get; set; }

        public PickersForField(Schema.FieldSetMember field) {

            Schema.SObjectType sObj = Schema.getGlobalDescribe().get(WORKING_PRODUCT_NAME);
            this.chosedItems = new List<String>();
            this.isDBRequired = field.getDbRequired();
            this.isRequired = field.getRequired();
            this.fieldType = String.valueOf(field.getType());
            this.fieldLabel = field.getLabel() ;
            this.fieldAPIName = field.getFieldPath() ;
            if (String.valueOf(field.getType()) == 'PICKLIST' ||
                    String.valueOf(field.getType()) == 'MULTIPICKLIST') {
                this.pickListValues = getPickersForField(sObj.getDescribe().fields.getMap().get(field.getFieldPath())
                        .getDescribe().getPicklistValues(), field.getFieldPath());
            }
        }

    }

    public static List<PickersValues> getPickersForField(List<PicklistEntry> picklistEntries, String field) {
        List<PickersValues> result = new List<PickersValues>();
        System.debug(' * INFO : picklistEntries : ' + picklistEntries);
        System.debug(' * INFO : picklistEntries : ' + picklistEntries);
        for (PicklistEntry pe : picklistEntries) {
            Integer count = 0;
            for (Product2 pr : ShopService.allProducts) {
                System.debug(' * INFO : pr : ' + pr);
                System.debug(' * INFO : field : ' + field);
                if (pr.get(field) == pe.value) {
                    count++;
                }
            }
            result.add(new PickersValues(pe, count));
        }

        return result;
    }

    public class PickersValues {

        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String value { get; set; }
        @AuraEnabled
        public Boolean active { get; set; }
        @AuraEnabled
        public Boolean defaultValue { get; set; }
        @AuraEnabled
        public Integer amount { get; set; }
        @AuraEnabled
        public Boolean isSelected { get; set; }

        public PickersValues(PicklistEntry pe, Integer amount) {
            this.label = pe.label;
            this.value = pe.value;
            this.active = pe.active;
            this.defaultValue = pe.defaultValue;
            this.amount = amount;
            this.isSelected = false;
        }

    }

}