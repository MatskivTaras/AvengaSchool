@isTest
public class LineItemTriggerTest {
    @TestSetup
    static void dataSetup(){
        Product__c product1 = new Product__c(
            Name = 'product1',
            Price__c = 1.5,
            Available_Amount__c = 25
        );

        insert product1;

        Transaction__c transaction1 = new Transaction__c(Payment_Type__c = 'Visa', Status__c = 'Active');
        insert transaction1;

        Line_Item__c newLineItem = new Line_Item__c(
            Name = 'line item for test',
            Transaction__c = transaction1.Id,
            Product__c = product1.Id,
            Quantity__c = 10
        );
        insert newLineItem;
    }

    @isTest
    static void testInsertLineItem(){
        Transaction__c targetTransaction = [SELECT Id FROM Transaction__c];
        Product__c targetProduct = [SELECT Id, Available_Amount__c FROM Product__c WHERE Name = 'product1'];
        Line_Item__c newLineItem = new Line_Item__c(
            Name = 'new line item',
            Transaction__c = targetTransaction.Id,
            Product__c = targetProduct.Id,
            Quantity__c = 14
        );
        
        Test.startTest();
        Database.SaveResult sr = Database.insert(newLineItem);
        Test.stopTest();

        targetProduct = [SELECT Id, Available_Amount__c FROM Product__c WHERE Name = 'product1'];
        Double newAvailableAmount = targetProduct.Available_Amount__c;

        System.assert(sr.isSuccess(), 'LineItemTrigger : line item created');
        System.assert(newAvailableAmount == 1, 'LineItemTrigger.Insert : the product has been removed from the store');
    }

    @isTest
    static void testUpdateLineItem(){
        Line_Item__c lineItemForUpdate = [SELECT Id, Quantity__c FROM Line_Item__c];
        lineItemForUpdate.Quantity__c = 14;

        Test.startTest();
        Database.SaveResult sr = Database.update(lineItemForUpdate);
        Test.stopTest();

        Product__c targetProduct = [SELECT Id, Available_Amount__c FROM Product__c WHERE Name = 'product1'];

        System.assert(sr.isSuccess(), 'LineItemTrigger : line item updated');
        System.assert(targetProduct.Available_Amount__c == 11, 'LineItemTrigger.Update : the product has been updated in the store');
    }
}
