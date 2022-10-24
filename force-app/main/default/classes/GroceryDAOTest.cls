@isTest
public class GroceryDAOTest {
    
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

        Transaction__c transaction1 = new Transaction__c(Payment_Type__c = 'Visa');
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
    static void getNumberOfSoldProductsTest(){
        Date startDate = Date.newInstance(2022, 10, 1);
        Date endDate = Date.newInstance(2022, 10, 31);

        Test.startTest();
        Map<ID, Double> numberOfSoldProductsMap = GroceryDAO.getNumberOfSoldProducts(startDate, endDate);
        Test.stopTest();

        System.assert(numberOfSoldProductsMap.size() == 2, 'GroceryDAO.getNumberOfSoldProducts : Two numbers of sold products');
    }

    @isTest
    static void getTotalAmountOfTransactionsTest(){
        List<Transaction__c> transactions = [SELECT Id FROM Transaction__c];
        Id transactionId = transactions.get(0).Id;

        Test.startTest();
        Map<Id, Double> totalAmountOfTransactionsMap = GroceryDAO.getTotalAmountOfTransactions(new Set<Id>{transactionId});
        Test.stopTest();

        System.assert(totalAmountOfTransactionsMap.size() == 1, 'GroceryDAO.getTotalAmountOfTransactions : One record in result map');
    }

    
    @isTest
    static void getTopSellersTest(){
        Integer limitNumber = 5;
        Integer offsetNumber = 0;
        Integer year = 2022;

        Test.startTest();
        List<Product__c> topSellers = GroceryDAO.getTopSellers(limitNumber, offsetNumber, year);
        Test.stopTest();

        System.assert(topSellers.size() == 2, 'GroceryDAO.getTopSellers : Two top sellers');
    }

    @isTest
    static void getPaymentStatisticsAmountTest(){
        Test.startTest();
        List<AggregateResult> paymentStatisticsAmount = GroceryDAO.getPaymentStatisticsAmount();
        Test.stopTest();

        System.assert(paymentStatisticsAmount.size() == 1, 'GroceryDAO.getPaymentStatisticsAmount : One Visa transaction');
    }

    @isTest
    static void getProductsTest(){
        Integer limitNumber = 1;
        Integer offsetNumber = 0;

        Test.startTest();
        List<Product__c> products = GroceryDAO.getProducts(limitNumber, offsetNumber);
        Test.stopTest();

        System.assert(products.size() == 1, 'GroceryDAO.getProducts : One product in list');
    }

    @isTest
    static void getProductAvailableInStoreTest(){
        Integer limitNumber = 10;
        Integer offsetNumber = 0;

        Test.startTest();
        List<Product__c> availableProducts = GroceryDAO.getProductAvailableInStore(limitNumber, offsetNumber);
        Test.stopTest();

        System.assert(availableProducts.size() == 2, 'GroceryDAO.getProductAvailableInStore : Two available products in store');
    }
}