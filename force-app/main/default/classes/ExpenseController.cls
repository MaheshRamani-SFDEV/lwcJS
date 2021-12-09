public with sharing class ExpenseController {
    // ns refers to namespace; leave out ns__ if not needed
    // This method is vulnerable.
    @AuraEnabled
    public static List<Expense__c> get_UNSAFE_Expenses() {
        return [SELECT Id, Name, Amount__c, Client__c, Date__c, Reimbursed__c, CreatedDate FROM Expense__c];
    }
    // This method is recommended.
    @AuraEnabled
    public static List<Expense__c> getExpenses() {
    	String [] expenseAccessFields = new String [] {'Id',
                                                    'Name',
                                                    'Amount__c',
                                                    'Client__c',
                                                    'Date__c',
                                                    'Reimbursed__c',
                                                    'CreatedDate'
                                                    };
        // Obtain the field name/token map for the Expense object
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Expense__c.fields.getMap();
        for (String fieldToCheck : expenseAccessFields) {
            // Check if the user has access to view field
            if (!m.get(fieldToCheck).getDescribe().isAccessible()) {
            	// Pass error to client
            	throw new System.NoAccessException();
            } 
        }
        // Query the object safely
        return [SELECT Id, Name, Amount__c, Client__c, Date__c, Reimbursed__c, CreatedDate FROM Expense__c];
    }
    @AuraEnabled
	public static Expense__c saveExpense(Expense__c expense) {
		// Perform isUpdateable() check here
		upsert expense;
		return expense;
	}
    @AuraEnabled
    public static Expense__c deleteExpense(Expense__c expense) {
    	// Perform isDeletable() check here
    	delete expense;
    	return expense;
    }
}