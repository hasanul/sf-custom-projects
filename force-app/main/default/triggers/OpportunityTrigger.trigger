trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            
        }
    } 
}