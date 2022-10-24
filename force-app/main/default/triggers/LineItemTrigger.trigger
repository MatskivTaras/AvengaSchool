trigger LineItemTrigger on Line_Item__c (before insert, before update, after insert, after update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            LineItemTriggerHandler.onBeforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            LineItemTriggerHandler.onBeforeUpdate(Trigger.new);
        }

    } else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            LineItemTriggerHandler.onAfterInsert(Trigger.oldMap, Trigger.new);
        } else if (Trigger.isUpdate) {
            LineItemTriggerHandler.onAfterUpdate(Trigger.oldMap, Trigger.new);
        }
    }
}