public class GroceryServices {
    public static DataBase.SaveResult createTransaction(String paymentType) {
        
    }

    public static List<Transaction__c> filterValidTransactions(List<Transaction__c> transactionsList) {
        Set<String> filterStatus = new Set<String>{'Active', 'Closed'};
        List<Transaction__c> filtredTransactions = new List<Transaction__c>();

        for(Transaction__c transactionItem:transactionsList){
            if(filterStatus.contains(transactionItem.Status__c)){
                filtredTransactions.add(transactionItem);
            }
        }

        return filtredTransactions;
    }

    public static Double calculateTotalAmount(List<Line_Item__c> lineItemsList) {
        Double totalAmount = 0;

        for (Line_Item__c lineItem:lineItemsList) {
            totalAmount += lineItem.Amount__c;
        }
        return totalAmount;
    }
}