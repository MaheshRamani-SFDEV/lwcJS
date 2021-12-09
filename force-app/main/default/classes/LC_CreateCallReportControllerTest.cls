@isTest
public class LC_CreateCallReportControllerTest {    
    public static User thisUser = [SELECT Id from User WHERE Id = :UserInfo.getUserId()];
    @isTest
    Static void createEventToCallReportRecordTest(){
        //Test Data using Utility Class
        /*TestClassUtil ob = new TestClassUtil();
        Home_Center__c testHomeCenter = ob.createHomeCenterTestData('Beverage','100');
        Account testAccount = ob.createClientTestData(testHomeCenter.id);
        Opportunity testOpportunity = ob.createDealTestData(testAccount.id);
        Event testEvent = ob.createEventTestData(testOpportunity.id);
        Profile profile = [select id from Profile where name = 'System Administrator'];
        User testNewUserq= new User(alias='neUserq', email='newTestinguser1@test.com', emailencodingkey='UTF-8', lastname='Testing', username='newTestinguserq1@test.com',
                                    EmployeeNumber='123456780',profileid=profile.id, languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles'
                                    ,Owned__c='Beverage',Owned_Products__c='Foreign Exchange',Product_Home_Center_updated__c=true,User_Type__c='CIB',RACF_ID__c='YOU17');
        System.RunAs(thisUser)
        {
            insert testNewUserq;
        }  */     
        //Start Test
        Test.startTest();
        	String destObjName = 'Broker__c';    
        	//create Call Report
        	/*System.runAs(testNewUserq){       
            	Map<String, Object> returnObject = LC_CreateCallReportController.createRecord(testEvent.id, destObjName);
                System.assertEquals('Broker__c',returnObject.get('entityApiName'));   
            }*/
        Test.stopTest();
        //End Test             
    }
  
}