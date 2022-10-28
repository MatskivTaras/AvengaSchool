@isTest
public class IncreaseProductAvailableAmoutBatchTest {
    @TestSetup
    static void dataSetup(){
        Product__c product1 = new Product__c(
            Name = 'product1',
            Price__c = 1.5,
            Available_Amount__c = 200
        );
        Product__c product2 = new Product__c(
            Name = 'product2',
            Price__c = 4,
            Available_Amount__c = 100
        );
        insert new List<Product__c>{product1, product2};

        Transaction__c transaction1 = new Transaction__c(Payment_Type__c = 'Visa');
        insert transaction1;

        Line_Item__c lineItem1 = new Line_Item__c(
            Name = 'sale product1',
            Transaction__c = transaction1.Id,
            Product__c = product1.Id,
            Quantity__c = 150
        );
        Line_Item__c lineItem2 = new Line_Item__c(        
            Name = 'sale product2',
            Transaction__c = transaction1.Id,
            Product__c = product2.Id,
            Quantity__c = 70
        );
        insert new List<Line_Item__c>{lineItem1, lineItem2};
    }

    @isTest
    static void executeBatchTest() {
        Product__c beforeBatchProduct = [SELECT Available_Amount__c FROM Product__c WHERE Name = 'product1'];
        IncreaseProductAvailableAmoutBatch incProductAvailableAmoutBatch = new IncreaseProductAvailableAmoutBatch();

        Test.startTest();
        Id batchId = Database.executeBatch(incProductAvailableAmoutBatch);
        Test.stopTest();

        AsyncApexJob job = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID = :batchId];
        Product__c afterBatchProduct = [SELECT Available_Amount__c FROM Product__c WHERE Name = 'product1'];

        System.assert(
            afterBatchProduct.Available_Amount__c == beforeBatchProduct.Available_Amount__c + 10,
            'IncreaseProductAvailableAmoutBatch.execute : product available amount increase on ten'
        );        
    }
}