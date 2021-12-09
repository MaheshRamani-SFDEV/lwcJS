public with sharing class AccountListController {
    @AuraEnabled
    public static List<Account> getAccountList() {
        list<Account> AccountList = [SELECT Id,Name,OwnerId,AnnualRevenue,Industry,Phone FROM Account Limit 5];
        if ( AccountList.size() == 0 ) {
        	AuraHandledException e = new AuraHandledException('No Accounts Found');
            e.setMessage('No Accounts Found');
            throw e;
        }
        return AccountList;
    }    
}