public class GroceryServices {
    public static Database.SaveResult createTransaction(String paymentType) {
        Transaction__c newTransaction = new Transaction__c();
        newTransaction.Payment_Type__c = paymentType;
        
        Database.SaveResult sr = Database.insert(newTransaction);

        return sr;
    }

    public static Database.SaveResult createTransaction(String paymentType, List<LineItemDTO> lineItemDTOs) {
        Transaction__c newTransaction = new Transaction__c();
        newTransaction.Payment_Type__c = paymentType;
        
        Database.SaveResult sr = Database.insert(newTransaction);
        if (!sr.isSuccess()) {
            return sr;
        }

        List<Line_Item__c> newLineItems = new List<Line_Item__c>();  
        for (LineItemDTO dtoItem : lineItemDTOs) {
            Line_Item__c newLineItem = new Line_Item__c();
            newLineItem.Transaction__c = newTransaction.Id;
            newLineItem.Name = dtoItem.name;

            newLineItems.add(newLineItem);
        }

        try {
            insert(newLineItems);
        } catch (DMLException e) {
            System.debug('Can not insert Line Items for transaction' + newTransaction.Id + '.\n' + e.getMessage());    
        }

        return sr;
    }

    public static Database.SaveResult createLineItem(Id transactionId, Id productId, Double amount) {
        Line_Item__c newLineItem = new Line_Item__c();
        newLineItem.Transaction__c = transactionId;
        newLineItem.Product__c = productId;
        newLineItem.Amount__c = amount;

        Database.SaveResult sr = Database.insert(newLineItem);

        return sr;
    }

    public static void cancelTransaction(Id transactionId) {
        Transaction__c targetTransaction = [SELECT Name FROM Transaction__c WHERE Id = :transactionId];
        targetTransaction.Status__c = 'Cancelled';

        try {
            update(targetTransaction);            
        } catch (DmlException e) {
            System.debug('Can not canseled transaction' + targetTransaction.Name + '.\n' + e.getMessage());            
        }        
    }

    public static void deleteLineItem(Id lineItemId) {
        Line_Item__c targetLineItem = [SELECT Name FROM Line_Item__c WHERE Id = :lineItemId];

        try {
            delete(targetLineItem);            
        } catch (DmlException e) {
            System.debug('Can not delete line item' + targetLineItem.Name + '.\n' + e.getMessage());            
        }                 
    }

    public static List<Transaction__c> filterValidTransactions(List<Transaction__c> transactionsList) {
        Set<String> filterStatus = new Set<String>{'Active', 'Closed'};
        List<Transaction__c> filtredTransactions = new List<Transaction__c>();

        for (Transaction__c transactionItem : transactionsList) {
            if(filterStatus.contains(transactionItem.Status__c)) {
                filtredTransactions.add(transactionItem);
            }
        }

        return filtredTransactions;
    }

    public static Double calculateTotalAmount(List<Line_Item__c> lineItemsList) {
        Double totalAmount = 0;

        for (Line_Item__c lineItem : lineItemsList) {
            totalAmount += lineItem.Amount__c;
        }

        return totalAmount;
    }
}