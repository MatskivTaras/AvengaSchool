@RestResource(urlMapping='/FiveProductsWithHighestPrice/*')
global class ProductControllerREST {

    @HttpGet
    global static List<Product__c> getProductsWithHighestPrice() {
        return [
            SELECT Name, Price__c
            FROM Product__c
            ORDER BY Price__c DESC
            LIMIT 5
        ];
    }
}
