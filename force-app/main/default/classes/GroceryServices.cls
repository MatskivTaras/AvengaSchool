public class GroceryServices {
    public static Database.SaveResult createTransaction(String paymentType) {
        Transaction__c newTransaction = new Transaction__c(
            Payment_Type__c = paymentType
        );
        
        Database.SaveResult sr = Database.insert(newTransaction);

        return sr;
    }

    public static Database.SaveResult createTransaction(String paymentType, List<LineItemDTO> lineItemDTOs) {
        Transaction__c newTransaction = new Transaction__c(
            Payment_Type__c = paymentType
        );
        
        Database.SaveResult sr = Database.insert(newTransaction);
        if (!sr.isSuccess()) {
            return sr;
        }

        List<Line_Item__c> newLineItems = new List<Line_Item__c>();
        for (LineItemDTO dtoItem : lineItemDTOs) {
            Line_Item__c newLineItem = new Line_Item__c(
                Transaction__c = newTransaction.Id,
                Name = dtoItem.name,
                Product__c = dtoItem.productId,
                Quantity__c = dtoItem.quantity
            );

            newLineItems.add(newLineItem);
        }

        try {
            insert(newLineItems);
        } catch (DMLException insException) {
            System.debug('Can not insert Line Items for transaction' + sr.getId() + '.\n' + insException.getMessage());

            cancelTransaction(sr.getId());
        }

        return sr;
    }

    public static Database.SaveResult createLineItem(Id transactionId, Id productId, Double quantity) {
        Line_Item__c newLineItem = new Line_Item__c(
            Transaction__c = transactionId,
            Product__c = productId,
            Quantity__c = quantity
        );

        Database.SaveResult sr = Database.insert(newLineItem);

        return sr;
    }

    public static void cancelTransaction(Id transactionId) {
        Transaction__c transactionForUpdate = new Transaction__c(
            Id = transactionId,
            Status__c = 'Cancelled'
        );

        try {
            update(transactionForUpdate);
        } catch (DmlException e) {
            System.debug('Can not canseled transaction' + transactionId + '.\n' + e.getMessage());
        }        
    }

    public static void deleteLineItem(Id lineItemId) {
        Line_Item__c lineItemForDelete = new Line_Item__c(Id = lineItemId);

        try {
            delete(lineItemForDelete);
        } catch (DmlException e) {
            System.debug('Can not delete line item' + lineItemId + '.\n' + e.getMessage());
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