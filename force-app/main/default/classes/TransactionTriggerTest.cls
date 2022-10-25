@isTest
public class TransactionTriggerTest {
    @TestSetup
    static void dataSetup(){
        Product__c product1 = new Product__c(
            Name = 'product1',
            Price__c = 1.5,
            Available_Amount__c = 150
        );

        insert product1;

        Transaction__c transaction1 = new Transaction__c(Payment_Type__c = 'Visa', Status__c = 'Active');
        insert transaction1;

        Line_Item__c lineItem1 = new Line_Item__c(
            Name = 'sale product1',
            Transaction__c = transaction1.Id,
            Product__c = product1.Id,
            Quantity__c = 5
        );
        insert lineItem1;
    }

    @isTest
    static void testCancelledTransaction() {
        Transaction__c transactionForUpdate = [SELECT Id FROM Transaction__c LIMIT 1];

        Test.startTest();
        transactionForUpdate.Status__c = 'Cancelled';
        Database.SaveResult sr = Database.update(transactionForUpdate);
        Line_Item__c targetLineItem = [
            SELECT Product__c, Product__r.Available_Amount__c
            FROM Line_Item__c
            WHERE Transaction__c = :transactionForUpdate.Id
        ];
        Test.stopTest();

        System.assert(sr.isSuccess(), 'TransactionTriger : transaction status updated to Cancelled');
        System.assert(targetLineItem.Product__r.Available_Amount__c == 150, 'TransactionTriger : product available amount returned to store');
    }
}
