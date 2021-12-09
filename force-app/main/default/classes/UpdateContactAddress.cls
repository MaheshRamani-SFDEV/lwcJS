global class UpdateContactAddress implements Database.Batchable <sObject>, Database.Stateful{
    
    global Integer processedRecords = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT ID, BillingStreet, Billing City, BillingState, '+
                                        ' BillingPostalCode, (SELECT ID, MailingStreet, MailingCity, '+
                                        'MailingState, MailingPostalCode FROM contacts) FROM Account '+
                                        'WHERE BillingCountry = \'USA\'');
    }
    
    global void execute(Database.batchableContext bc, List<Account> scope){
        List<Contact> contacts = new List<Contact>();
        for(Account account : scope){
            for(Contact contact : account.contacts){
                contact.MailingStreet = account.BillingStreet;
                contact.MailingCity = account.Billingcity;
                contact.MailingState = account.BillingState;
                contact.MailingPostalCode = account.BillingPostalCode;
            	contacts.add(contact);
            	processedRecords = processedRecords + 1;
            }
        }
        update contacts;
    }
    
    global void finish(Database.BatchableContext bc){
    	System.debug(processedRecords+ ' record processed. Congratulation!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob WHERE Id = :bc.getJobId()];
        //EmailUtils.sendMessage(job, processedRecords);
    }
}