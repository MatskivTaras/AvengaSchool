@RestResource(urlMapping='/TopTenSellersInYear/*')
global class ProductControllerREST {

    @HttpGet
    global static List<Product__c> getTopTenSellers() {
        Integer currentYear = System.Today().year();

        List<Product__c> topSellers = GroceryDAO.getTopSellers(10, 0, currentYear);

        return topSellers;
    }
}
