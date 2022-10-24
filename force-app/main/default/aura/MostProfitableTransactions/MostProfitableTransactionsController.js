({
	doInit : function(component, event, helper) {
		helper.setColumns(component);
        helper.getTransactions(component, event, helper);
	},
    
    reloadTransactions : function(component, event, helper) {
        helper.getTransactions(component, event, helper);
	}
})