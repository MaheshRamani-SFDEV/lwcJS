trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {    
    List<BatchLeadConvertErrors__c> listleadConverterrs = new List<BatchLeadConvertErrors__c>();    
    for (BatchApexErrorEvent evt:Trigger.new){            
        BatchLeadConvertErrors__c batchleadconerror= new BatchLeadConvertErrors__c();
        batchleadconerror.AsyncApexJobId__c=evt.AsyncApexJobId;                                     
        batchleadconerror.Records__c=evt.JobScope;                                                   
        batchleadconerror.StackTrace__c=evt.StackTrace;            
        listleadConverterrs .add(batchleadconerror);        
    }     
    insert listleadConverterrs; 
}