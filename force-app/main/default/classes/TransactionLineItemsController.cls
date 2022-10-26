public class TransactionLineItemsController {
    @AuraEnabled(cacheable=true)
    public static List<Line_Item__c> getTransactionLineItems(Id transactionId) {
        return [
            SELECT Id, Name, Product_Name_With_Code__c, Quantity__c, Amount__c
            FROM Line_Item__c
            WHERE Transaction__c = :transactionID
        ];
    }
}