public with sharing class Opportunity_Utility {
    public static void setOpportunityPriceBook(List<Opportunity> listOpportunity){

        ID pb1 = '01s2p0000011CJmAAM';
        String Edition1 = 'Edition-1';

        for (Opportunity opp : listOpportunity) {
            opp.Pricebook2Id = pb1;
        }
    }
}