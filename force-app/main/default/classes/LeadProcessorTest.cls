@isTest
private class LeadProcessorTest {
	@testSetup
    static void setup(){
        List<Lead> leads = new List<Lead>();
        for(Integer i=0; i<200 ;i++){
            leads.add(new Lead(FirstName='FTest'+i,
                			   LastName='LTest'+i,
                               Company='TestComp',
                               CurrencyIsoCode=null,
                               Status=null,
                               LeadSource='Web'));
        }
        insert leads;
    }
    
    @isTest
    static void testLead(){
        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batchId = Database.executeBatch(lp);
        Test.stopTest();
        Lead l = [SELECT Id, Company, LeadSource FROM Lead WHERE LeadSource = 'Dreamforce'];
    	System.assertEquals('TestCompany', l.Company);
        System.assertEquals('Dreamforce', l.LeadSource);
    }
}