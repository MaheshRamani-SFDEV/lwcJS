global class AccountProcessor {
	@future
    global static void countContacts(List<Id> AcctId){   	
        for(Account acct : [SELECT Number_of_Contacts__c FROM Account WHERE Id IN :AcctId]){
        Integer contCount = 0;
        contCount = [SELECT COUNT() FROM Contact WHERE Contact.AccountId = :acct.Id];
        acct.Number_of_Contacts__c = contCount;	
        System.debug('total Contacts on account is: ' + contCount);    
        update acct;
        }
    }
}