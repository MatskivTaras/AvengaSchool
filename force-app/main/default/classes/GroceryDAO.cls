public class GroceryDAO {
    public static Map<Id, Double> getNumberOfSoldProducts(Date startDate, Date endDate) {
        List<Line_Item__c> lineItems = [
            SELECT Product__r.Id, Quantity__c
            FROM Line_Item__c
            WHERE (DAY_ONLY(Transaction__r.CreatedDate) >= :startDate) AND (DAY_ONLY(Transaction__r.CreatedDate) <= :endDate)
        ];

        Map<ID, Double> numberOfSoldProducts = new Map<ID, Double>();
        for (Line_Item__c lineItem : lineItems) {
            numberOfSoldProducts.put(lineItem.Product__r.Id, lineItem.Quantity__c);
        }
        
        return numberOfSoldProducts;
    }

    public static Map<Id, Double> getTotalAmountOfTransactions(Set<Id> transactionIds) {
        List<AggregateResult> aggResults = [
            SELECT Transaction__r.Id trId, SUM(Amount__c) totalAmount
            FROM Line_Item__c
            WHERE Transaction__r.Id IN :transactionIds
            GROUP BY Transaction__r.Id
        ];

        Map<ID, Double> totalAmountOfTransactions = new Map<ID, Double>();
        for (AggregateResult aggResItem : aggResults) {
            totalAmountOfTransactions.put((Id)aggResItem.get('trId'), (Double)aggResItem.get('totalAmount'));
        }

        return totalAmountOfTransactions;  
    }

    public static List<Product__c> getTopSellers(Integer limitNumber, Integer offsetNumber, Integer year) {
        List<Line_Item__c> lineItems = [
            SELECT Product__c
            FROM Line_Item__c
            WHERE CALENDAR_YEAR(CreatedDate) = :year
            ORDER BY Quantity__c DESC
            LIMIT :limitNumber
            OFFSET :offsetNumber
        ];

        Map<Id, Product__c> products = new Map<Id, Product__c>([SELECT Id, Name FROM Product__c]);

        List<Product__c> topSellers = new List<Product__c>();
        for (Line_Item__c lineItem : lineItems) {
            topSellers.add(products.get(lineItem.Product__c));
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

    public static List<Product__c> getProducts(Integer limitNumber, Integer offsetNumber) {
        return  [SELECT Id, Name FROM Product__c LIMIT :limitNumber OFFSET: offsetNumber];
    }

    public static List<Product__c> getProductAvailableInStore(Integer limitNumber, Integer offsetNumber) {
        return [SELECT Id, Name FROM Product__c WHERE Available_Amount__c > 0 LIMIT :limitNumber OFFSET: offsetNumber];    
    }
}
