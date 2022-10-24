@isTest
public class TestDataFactory {
    public static Product__c createProduct(String name, Double price, Double availableAmount) {
        Product__c product = new Product__c(
            Name = name,
            Price__c = price,
            Available_Amount__c = availableAmount
        );
        insert product;
        return product;
    }

    public static Transaction__c createTransaction() {
        Transaction__c newTransaction = new Transaction__c();
        insert newTransaction;
        return newTransaction;
    }

    public static Line_Item__c createLineItem(String name, Id transactionId, Id productId, Double quantity) {
        Line_Item__c newLineItem = new Line_Item__c(
            Name = name,
            Transaction__c = transactionId,
            Product__c = productId,
            Quantity__c = quantity
        );
        insert newLineItem;
        return newLineItem;
    }
}
