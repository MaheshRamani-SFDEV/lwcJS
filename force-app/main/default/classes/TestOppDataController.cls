@isTest
private class TestOppDataController{
    static testMethod void testOpp() {
        //Create new expense and insert it into the database        
        Account acc = new Account();
        acc.Name = 'Test Data';
        insert acc;
        
        Id RecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Client1').getRecordTypeId();
        
        Opportunity opp = new Opportunity();
        opp.AccountID = acc.Id;
        opp.recordTypeId = RecordTypeIdOpportunity;
        opp.CloseDate = date.today();
        opp.StageName = 'Prospecting';
        opp.Name = 'Opp 1';
        insert opp;
        
        list<OpportunityDataController.oppWrapper> listOpp = new list<OpportunityDataController.oppWrapper>();
        
        listOpp = OpportunityDataController.fetchOpportunities(acc.Id);
        
        System.assertEquals(true,listOpp.size()>0);
    }
}