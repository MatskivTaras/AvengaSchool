public class LineItemTriggerHandler {

    private static Map<Id, Product__c> productAvailableAmounts {get; set;}

    public static void onBeforeInsert(List<Line_Item__c> lineItems) {
        setNames(lineItems);
        checkQuantityAndAvaliableAmount(lineItems);
    }

    public static void onAfterInsert(Map<Id, Line_Item__c> oldLineItemsMap, List<Line_Item__c> newLineItems) {
        updateProductAvaliableAmount(oldLineItemsMap, newLineItems);
    }

    public static void onBeforeUpdate(List<Line_Item__c> lineItems) {
        checkQuantityAndAvaliableAmount(lineItems);
    }

    public static void onAfterUpdate(Map<Id, Line_Item__c> oldLineItemsMap, List<Line_Item__c> newLineItems) {
        updateProductAvaliableAmount(oldLineItemsMap, newLineItems);
    }

    private static void fillProductsAvailableAmounts(List<Line_Item__c> lineItems) {
        if (productAvailableAmounts != null) {
            return;
        }

        List<Id> productIds = new List<Id>();
        for (Line_Item__c lineItem : lineItems) {
            productIds.add(lineItem.Product__c);
        }

        productAvailableAmounts = new Map<Id, Product__c>([
            SELECT Id, Name, Available_Amount__c
            FROM Product__c
            WHERE Id IN :productIds
        ]);
    }

    private static void setNames(List<Line_Item__c> lineItems) {
        fillProductsAvailableAmounts(lineItems);

        for(Line_Item__c lineItem : lineItems) {
            lineItem.Name = GroceryServices.generateRecordName(
                'Line_Item__c',
                productAvailableAmounts.get(lineItem.Product__c).Name
            );
        }
    }

    private static void checkQuantityAndAvaliableAmount(List<Line_Item__c> lineItems) {
        fillProductsAvailableAmounts(lineItems);

        for (Line_Item__c lineItem : lineItems) {
            if (lineItem.Quantity__c > productAvailableAmounts.get(lineItem.Product__c).Available_Amount__c) {
                lineItem.Quantity__c.addError('Not available amount of ' + productAvailableAmounts.get(lineItem.Product__c).Name);
            }

            if ((lineItem.Quantity__c <= 0)||(lineItem.Quantity__c == null)) {
                lineItem.Quantity__c.addError('Quantity must be greater than zero.');
            }
        }
    }

    private static void updateProductAvaliableAmount(Map<Id, Line_Item__c> oldLineItemsMap, List<Line_Item__c> newLineItems) {
        fillProductsAvailableAmounts(newLineItems);
        List<Product__c> productsForUpdate = new List<Product__c>();

        for (Line_Item__c lineItem : newLineItems) {

            Double oldQuantity;
            if (oldLineItemsMap != null) {
                oldQuantity = oldLineItemsMap.get(lineItem.Id).Quantity__c;
            }
            Double newQuantity = lineItem.Quantity__c;
            if (oldQuantity == null) {
                oldQuantity = 0;
            }
            if (newQuantity == null) {
                newQuantity = 0;
            }

            if (oldQuantity != newQuantity) {
                Double newAvailableAmount = productAvailableAmounts.get(lineItem.Product__c).Available_Amount__c + oldQuantity - newQuantity;

                Product__c product = new Product__c(
                    Id = lineItem.Product__c,
                    Available_Amount__c = newAvailableAmount
                );
                productsForUpdate.add(product);
            }
        }

        if (!productsForUpdate.isEmpty()) {
            update(productsForUpdate);
        }
    }
}