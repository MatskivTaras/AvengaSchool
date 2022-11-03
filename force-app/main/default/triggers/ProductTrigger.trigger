trigger ProductTrigger on Product__c (before insert) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            ProductTriggerHandler.onBeforeInsert(Trigger.new);
        }
    }
}