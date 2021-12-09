global class LeadProcessor implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id, LeadSource FROM Lead';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> scope){
        for(Lead lead : scope){
            lead.LeadSource = 'Dreamforce';
        }
        update scope;
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug('All lead records successfully procesed');
    }
}