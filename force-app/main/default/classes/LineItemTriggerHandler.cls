public class LineItemTriggerHandler {

    private static Map<Id, Product__c> productAvailableAmounts {get; set;}

    public static void onBeforeInsert(List<Line_Item__c> lineItems) {

        List<Id> productIds = new List<Id>();
        for (Line_Item__c lineItem : lineItems) {
            productIds.add(lineItem.Product__c);
        }

        productAvailableAmounts = new Map<Id, Product__c>([SELECT Id, Name, Available_Amount__c FROM Product__c WHERE Id IN :productIds]);

        for (Line_Item__c lineItem : lineItems) {
            if (lineItem.Quantity__c > productAvailableAmounts.get(lineItem.Product__c).Available_Amount__c) {
                lineItem.Quantity__c.addError('Not available amount of '+productAvailableAmounts.get(lineItem.Product__c).Name);
            }
        }
    }

    public static void onAfterInsert(List<Line_Item__c> lineItems) {

        List<Product__c> productsForUpdate = new List<Product__c>();
        for (Line_Item__c lineItem : lineItems) {
            Product__c product = new Product__c(
                Id = lineItem.Product__c,
                Available_Amount__c = productAvailableAmounts.get(lineItem.Product__c).Available_Amount__c - lineItem.Quantity__c
            );
            productsForUpdate.add(product);
        }

        update(productsForUpdate);
    }
}
