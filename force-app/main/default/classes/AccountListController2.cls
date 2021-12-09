public with sharing class AccountListController2 {
    @AuraEnabled
    public static List<Account> getAccountList2() {
    	List<Account> accounts2 = new List<Account>();
        return accounts2;
    }    
}