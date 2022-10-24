@isTest
public class GroceryServicesTest {
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

        Line_Item__c lineItem1 = new Line_Item__c(
            Name = 'sale product1',
            Transaction__c = transaction1.Id,
            Product__c = product1.Id,
            Quantity__c = 5
        );
        Line_Item__c lineItem2 = new Line_Item__c(        
            Name = 'sale product2',
            Transaction__c = transaction1.Id,
            Product__c = product2.Id,
            Quantity__c = 7
        );
        insert new List<Line_Item__c>{lineItem1, lineItem2};
    }

    @isTest
    static void createTransactionTest(){
        List<Product__c> products = [SELECT Id FROM Product__c WHERE Available_Amount__c > 0 ORDER BY Name];

        List<LineItemDTO> lineItemDTOs = new List<LineItemDTO>();
        lineItemDTOs.add(new LineItemDTO('Sale position 1', products[0].Id, 1));
        lineItemDTOs.add(new LineItemDTO('Sale position 2', products[1].Id, 2));

        Test.startTest();
        Database.SaveResult sr = GroceryServices.createTransaction('MasterCard');
        Database.SaveResult srOverload = GroceryServices.createTransaction('Visa', lineItemDTOs);
        Test.stopTest();

        System.assert(sr.isSuccess(), 'GroceryServices.createTransaction : transaction created');
        System.assert(srOverload.isSuccess(), 'GroceryServices.createTransaction : transaction with line items created');
    }

    @isTest
    static void createLineItemTest(){
        Product__c targetProduct = [SELECT Id FROM Product__c WHERE Name = 'product1'];
        Transaction__c targetTransaction = [SELECT Id FROM Transaction__c LIMIT 1];
        Double quantity = 5.5;

        Test.startTest();
        Database.SaveResult sr = GroceryServices.createLineItem(targetTransaction.Id, targetProduct.Id, quantity);
        Test.stopTest();

        System.assert(sr.isSuccess(), 'GroceryServices.createLineItem : line item created');
    }

    @isTest
    static void cancelTransactionTest(){
        Transaction__c targetTransaction = [SELECT Id FROM Transaction__c LIMIT 1];

        Test.startTest();
        GroceryServices.cancelTransaction(targetTransaction.Id);
        Transaction__c canceledTransaction = [SELECT Status__c FROM Transaction__c WHERE Id = :targetTransaction.Id];
        Test.stopTest();

        System.assert(canceledTransaction.Status__c == 'Cancelled', 'GroceryServices.cancelTransaction : transaction cancelled');
    }

    @isTest
    static void deleteLineItemTest(){
        Line_Item__c targetLineItem = [SELECT Id FROM Line_Item__c LIMIT 1];

        Test.startTest();
        GroceryServices.deleteLineItem(targetLineItem.Id);
        Line_Item__c deletedLineItem = [SELECT Id, IsDeleted FROM Line_Item__c WHERE Id = :targetLineItem.Id ALL ROWS];
        Test.stopTest();

        System.assert(deletedLineItem.IsDeleted == true, 'GroceryServices.deleteLineItem : line item deleted');
    }

    @isTest
    static void filterValidTransactionsTest(){
        List<Transaction__c> transactions = [SELECT Id, Status__c FROM Transaction__c];
        Test.startTest();
        List<Transaction__c> validTransactions = GroceryServices.filterValidTransactions(transactions);
        Test.stopTest();

        System.assert(validTransactions.size() == 1, 'GroceryServices.filterValidTransactions : one valid transaction');
    }

    @isTest
    static void calculateTotalAmountTest(){
        List<Line_Item__c> lineItems = [SELECT Id, Amount__c FROM Line_Item__c];
        Test.startTest();
        Double totalAmount = GroceryServices.calculateTotalAmount(lineItems);
        Test.stopTest();

        System.assert(totalAmount != null, 'GroceryServices.calculateTotalAmount : total amount not null');
    }
}
