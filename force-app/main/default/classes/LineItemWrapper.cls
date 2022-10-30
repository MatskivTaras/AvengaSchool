public class LineItemWrapper {
    @AuraEnabled public String Id{get; set;}
    @AuraEnabled public String productName{get; set;}
    @AuraEnabled public String productCode{get; set;}
    @AuraEnabled public Integer transactionNumber{get; set;}
    @AuraEnabled public Double quantity{get; set;}
    @AuraEnabled public Double amount{get; set;}

    public LineItemWrapper(
        String productName,
        String productCode,
        Integer transactionNumber,
        Double quantity,
        Double amount
    ) {
        this.productName = productName;
        this.productCode = productCode;
        this.transactionNumber = transactionNumber;
        this.amount = amount;
        this.quantity = quantity;
    }
}
