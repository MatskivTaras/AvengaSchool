public class IncreaseProductAvailableAmoutBatch implements Database.Batchable<sObject>, Schedulable {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query =
            'SELECT Id, Available_Amount__c, (SELECT Quantity__c FROM Line_Items__r) ' +
            'FROM Product__c ' +
            'WHERE Id IN (SELECT Product__c FROM Line_Item__c WHERE CreatedDate = LAST_N_DAYS:30)';

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Product__c> products) {
        GroceryServices.updateProductsWitchIncreased(products);
    }

    public void finish(Database.BatchableContext bc) {
        //Some actions
    }

    public void execute(SchedulableContext sc) {
        IncreaseProductAvailableAmoutBatch incProductAvailableAmoutBatch = new IncreaseProductAvailableAmoutBatch();
        Id batchId = Database.executeBatch(incProductAvailableAmoutBatch);
    }
}