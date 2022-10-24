@isTest
public class LineItemTriggerTest {
    @TestSetup
    static void dataSetup(){
        Product__c product1 = new Product__c(
            Name = 'product1',
            Price__c = 1.5,
            Available_Amount__c = 150
        );

        Product__c product2 = new Product__c(
            Name = 'product2',
            Price__c = 4,
            Available_Amount__c = 100
        );

        Product__c product3 = new Product__c(
            Name = 'product3',
            Price__c = 1
        );

        insert new List<Product__c>{product1, product2, product3};

        Transaction__c transaction1 = new Transaction__c(Payment_Type__c = 'Visa', Status__c = 'Active');
        insert transaction1;
    }

    @isTest
    static void testInsertLineItem(){
        Transaction__c targetTransaction = [SELECT Id FROM Transaction__c LIMIT 1];
        Product__c targetProduct = [SELECT Id FROM Product__c WHERE Name = 'product1'];
        Test.startTest();
        Line_Item__c newLineItem = new Line_Item__c(
            Name = 'new line item',
            Transaction__c = targetTransaction.Id,
            Product__c = targetProduct.Id,
            Quantity__c = 14
        );
        Database.SaveResult sr = Database.insert(newLineItem);
        Test.stopTest();

        System.assert(sr.isSuccess(), 'LineItemTrigger : line item created');
    }
}
