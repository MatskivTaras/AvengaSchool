public class GroceryDAO {
    public static Map<Id, Double> getNumberOfSoldProducts(Date startDate, Date endDate) {
        List<Line_Item__c> lineItems = [
            SELECT Product__r.Id, Quantity__c
            FROM Line_Item__c
            WHERE (Transaction__r.CreatedDate >= :startDate) AND (Transaction__r.CreatedDate <= :endDate)
        ];

        Map<ID, Double> numberOfSoldProducts = new Map<ID, Double>();
        for (Line_Item__c lineItem : lineItems) {
            numberOfSoldProducts.put(lineItem.Product__r.Id, lineItem.Quantity__c);
        }
        
        return numberOfSoldProducts;
    }

    public static Map<Id, Double> getTotalAmountOfTransactions(Set<Id> transactionIds) {
        List<AggregateResult> aggResults = [
            SELECT Transaction__c, SUM(Amount__c) totalAmount
            FROM Line_Item__c
            WHERE Transaction__r.Id IN :transactionIds
            GROUP BY Transaction__c
        ];

        Map<ID, Double> totalAmountOfTransactions = new Map<ID, Double>();
        for (AggregateResult aggResItem : aggResults) {
            totalAmountOfTransactions.put((Id)aggResItem.get('Transaction__c'), (Double)aggResItem.get('totalAmount'));
        }

        return totalAmountOfTransactions;  
    }

    public static List<Product__c> getTopSellers(Integer limitNumber, Integer offsetNumber, Integer year) {
        List<Product__c> topSellers = new List<Product__c>();

        List<AggregateResult> aggResults = [
            SELECT Product__c, SUM(Quantity__c) totalQuantity
            FROM Line_Item__c
            WHERE CALENDAR_YEAR(CreatedDate) = :year
            GROUP BY Product__c
            ORDER BY SUM(Quantity__c) DESC
            LIMIT :limitNumber
            OFFSET :offsetNumber
        ];

        List<Id> productIds = new List<Id>();
        for (AggregateResult aggRes : aggResults) {
            productIds.add((Id)aggRes.get('Product__c'));
        }

        Map<Id, Product__c> products = new Map<Id, Product__c>([SELECT Id, Name FROM Product__c WHERE Id IN :productIds]);

        for (AggregateResult aggRes : aggResults) {
            topSellers.add(products.get((Id)aggRes.get('Product__c')));
        }

        return topSellers;
    }

    public static List<AggregateResult> getPaymentStatisticsAmount() {
        return [
            SELECT Transaction__r.Payment_Type__c, SUM(Quantity__c) sumQuantity
            FROM Line_Item__c
            GROUP BY Transaction__r.Payment_Type__c
        ];
    }

    public static List<Product__c> getProducts(Integer limitNumber, Integer offsetNumber, Boolean withAllFields) {
        if (withAllFields) {
            return  [SELECT Id, Name, Code__c, Available_Amount__c, Price__c FROM Product__c LIMIT :limitNumber OFFSET: offsetNumber];
        } else {
            return  [SELECT Id, Name FROM Product__c LIMIT :limitNumber OFFSET: offsetNumber];
        }
    }

    public static List<Product__c> getProductAvailableInStore(Integer limitNumber, Integer offsetNumber) {
        return [SELECT Id, Name FROM Product__c WHERE Available_Amount__c > 0 LIMIT :limitNumber OFFSET: offsetNumber];    
    }

    public static String getProductsJSON(Integer limitNumber, Integer offsetNumber) {
        List<Product__c> products = [
            SELECT Id, Name, Code__c, Available_Amount__c, Price__c
            FROM Product__c
            LIMIT :limitNumber
            OFFSET :offsetNumber
        ];
        
        String productsJSON = JSON.serialize(products);

        return productsJSON;
    }
}