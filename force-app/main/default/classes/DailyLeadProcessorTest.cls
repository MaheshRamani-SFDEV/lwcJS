@isTest
public class DailyLeadProcessorTest {
	public static string Cron_Exp = '0 55 3 21 8 ? 2018';
    @isTest
    static void Test(){
        List<Lead> leads = new List<Lead>();
        for(Integer i=0; i<200 ;i++){
            Lead l = new Lead(FirstName='SFTestt'+i,
                			   LastName='SLTestt'+i,
                               Company='STestComp',
                               CurrencyIsoCode=null,
                               Status=null,
                               LeadSource='');
            leads.add(l);
        }
        insert leads;
        
        Test.startTest();
        	System.Schedule('Lead Record Process Job', Cron_Exp, new DailyLeadProcessor());
        Test.stopTest();
    }
}