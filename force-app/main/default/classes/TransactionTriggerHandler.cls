public class TransactionTriggerHandler {

    public static void onBeforeInsert(List<Transaction__c> transactions) {
        for (Transaction__c transactionItem : transactions) {
            transactionItem.Name = GroceryServices.generateRecordName('Transaction__c', '');
        }
    }

    public static void onAfterUpdate(List<Transaction__c> transactions) {

        List<Id> cancelledTransactionIds = new List<Id>();
        for (Transaction__c trItem : transactions) {
            if (trItem.Status__c == 'Cancelled') {
                cancelledTransactionIds.add(trItem.Id);
            }
        }

        if (cancelledTransactionIds.isEmpty()) {
            return;
        }

        List<AggregateResult> aggResults = [
            SELECT Product__c, MAX(Product__r.Available_Amount__c) availableAmount, SUM(Quantity__c) totalQuantity
            FROM Line_Item__c
            WHERE Transaction__c IN :cancelledTransactionIds
            GROUP BY Product__c
        ];

        List<Product__c> productsForUpdate = new List<Product__c>();
        for (AggregateResult aggRes : aggResults) {
            Product__c product = new Product__c(
                Id = (Id)aggRes.get('Product__c'),
                Available_Amount__c = (Double)aggRes.get('availableAmount') + (Double)aggRes.get('totalQuantity')
            );

            productsForUpdate.add(product);
        }

        update(productsForUpdate);
    }
}