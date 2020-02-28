trigger OpportunityTrigger on Opportunity (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        Opportunity_Utility.setOpportunityPriceBook(trigger.new);
    }
}