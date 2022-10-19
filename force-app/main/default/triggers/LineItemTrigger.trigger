trigger LineItemTrigger on Line_Item__c (before insert, after insert) {
    if (Trigger.isBefore) {

        if (Trigger.isInsert) {
            LineItemTriggerHandler.onBeforeInsert(Trigger.new);
        }

    } else if (Trigger.isAfter) {
          
        if (Trigger.isInsert) {
            LineItemTriggerHandler.onAfterInsert(Trigger.new);
        }
    }
}