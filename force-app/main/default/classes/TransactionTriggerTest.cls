@isTest
public class TransactionTriggerTest {
    @TestSetup
    static void dataSetup(){
        Transaction__c transaction1 = new Transaction__c(Payment_Type__c = 'Visa');
        insert transaction1;
    }

    @isTest
    static void testCancelledTransaction() {
        Transaction__c transactionForUpdate = [SELECT Id FROM Transaction__c LIMIT 1];

        Test.startTest();
        transactionForUpdate.Status__c = 'Cancelled';
        Database.SaveResult sr = Database.update(transactionForUpdate);
        Test.stopTest();

        System.assert(sr.isSuccess(), 'TransactionTriger : transaction status updated to Cancelled');
    }
}
