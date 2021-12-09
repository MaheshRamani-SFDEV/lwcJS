public with sharing class BigObjectController {

    @AuraEnabled
    public static List<Account> getLimitedAccounts(){
        List<Account> accounts = [SELECT Id, Name, Phone, Rating FROM Account LIMIT 20];
        return accounts;
    }
}