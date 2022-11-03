public class ProductTriggerHandler {
    private static Map<String, Integer> getProductsWithSameName(List<Product__c> products) {
        List<String> productNameList = new List<String>();
        for (Product__c product : products) {
            productNameList.add(product.Name);
        }

        List<AggregateResult> aggResults = [
            SELECT Name, COUNT(Id) idCount
            FROM Product__c
            WHERE Name IN :productNameList
            GROUP BY Name
        ];

        Map<String, Integer> productCountMap = new Map<String, Integer>();
        for (AggregateResult ar : aggResults) {
            productCountMap.put(
                (String)ar.get('Name'),
                (Integer)ar.get('idCount')
            );
        }

        return productCountMap;
    }

    public static void onBeforeInsert(List<Product__c> products) {
        Map<String, Integer> productCountMap = getProductsWithSameName(products);
        for (Product__c product : products) {
            if (productCountMap.get(product.Name) > 0) {
                product.Name.addError('Product with same name already exist.');
            }
        }
    }
}