//This class is imported from org rd30/mahesh Ramani
public with sharing class AccountController {
  public static List<Account> getAllActiveAccounts() {
    return [SELECT Id,Name,Active__c FROM Account WHERE Active__c = 'No'];
  }
}