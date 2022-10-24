({
    setColumns : function(component) {
        component.set('v.columns', [
            {label: 'Transaction', fieldName: 'Name', type: 'text'},
            {label: 'Amount', fieldName: 'Total_Amount__c', type: 'double'},
            {label: 'Payment type', fieldName: 'Payment_Type__c', type: 'text'},
            {label: 'Status', fieldName: 'Status__c', type: 'text'}
        ]);
    },
    
    getTransactions : function(component, event, helper) {
		var action = component.get("c.getMostProfitableTransactions");
        
        action.setParams({
            "limitNumber": component.get("v.limitNumber")
        });
        
        action.setCallback(this, function(response) {
			component.set("v.transactions", response.getReturnValue());
        });
        
        $A.enqueueAction(action);
	}
})