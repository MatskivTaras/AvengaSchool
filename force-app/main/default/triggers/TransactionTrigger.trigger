trigger TransactionTrigger on Transaction__c (before insert, after update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            TransactionTriggerHandler.onBeforeInsert(Trigger.new);
        }
    } else if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            TransactionTriggerHandler.onAfterUpdate(Trigger.new);
        }
    }
}