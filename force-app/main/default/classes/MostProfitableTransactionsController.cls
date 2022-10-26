public class MostProfitableTransactionsController {
    @AuraEnabled
    public static List<Transaction__c> getMostProfitableTransactions(Integer limitNumber){
        return [
            SELECT Id, Name, Total_Amount__c, Payment_Type__c, Status__c
            FROM Transaction__c
            WHERE Total_Amount__c != NULL
            ORDER BY Total_Amount__c DESC
            LIMIT :limitNumber
        ];
    }
}