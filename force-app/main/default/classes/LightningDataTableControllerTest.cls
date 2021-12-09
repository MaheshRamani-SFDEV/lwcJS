//Description of component



//
@isTest(SeeAllData=False)
public class LightningDataTableControllerTest{
    @testSetup
    static void testData(){
        List<Account> accList = new List<Account>();
        for(Integer i= 0;i<100;i++){
        	Account acc = new Account(Name='Test '+i);
            accList.add(acc);
        }
        insert accList;
    }
    @isTest
    private static void getRecordsTest(){
        Profile profile = [select id from Profile where name = 'System Administrator'];
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        User testUser= new User(alias='neUser', email='newTestinguser@test.com', emailencodingkey='UTF-8', lastname='Testing', username='getRecordsTest@test.com',
                                EmployeeNumber='123456780',profileid=profile.id, languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles'); 
        system.runAs(usr){                                             
            insert testUser;
        } 
        List<Account> accRecs = [SELECT Id From Account WHERE Name LIKE 'Test%'];
        LightningDataTableController.DataTableResponse dataTableResponse = new LightningDataTableController.DataTableResponse();          	
        Test.startTest();
        	dataTableResponse = LightningDataTableController.getRecords('Account','dataTableFieldSet','2000');
        Test.stopTest();   
        List<Account> accList = dataTableResponse.lstDataTableData;
        System.assertEquals(accRecs.size(), accList.size());
    }
    
    @isTest
    private static void getURLTest(){
        Profile profile = [select id from Profile where name = 'System Administrator'];
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        User testUser= new User(alias='neUser', email='newTestinguser@test.com', emailencodingkey='UTF-8', lastname='Testing', username='getRecordsTest@test.com',
                                EmployeeNumber='123456780',profileid=profile.id, languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles'); 
        system.runAs(usr){                                             
            insert testUser;
        }
        Test.startTest();
        	LightningDataTableController.getURL();
        Test.stopTest();        
    }
    
	@isTest
    private static void getUIThemeTest(){
        String userTheme;
        Profile profile = [select id from Profile where name = 'System Administrator'];
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        User testUser= new User(alias='neUser', email='newTestinguser@test.com', emailencodingkey='UTF-8', lastname='Testing', username='getRecordsTest@test.com',
                                EmployeeNumber='123456780',profileid=profile.id, languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles'); 
        system.runAs(usr){                                             
            insert testUser;
        }
        Test.startTest();
        	userTheme = LightningDataTableController.getUITheme();
        Test.stopTest(); 
        System.assertEquals('Theme3', userTheme);
    }
    
    @isTest
    private static void deleteRecordTest(){
        Profile profile = [select id from Profile where name = 'System Administrator'];
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        User testUser= new User(alias='neUser', email='newTestinguser@test.com', emailencodingkey='UTF-8', lastname='Testing', username='getRecordsTest@test.com',
                                EmployeeNumber='123456780',profileid=profile.id, languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles'); 
        system.runAs(usr){                                             
            insert testUser;
        } 
        Account accDel = new Account(Name='Test DeleteAccount');
        insert accDel;
        Test.startTest();
        	LightningDataTableController.deleteRecord(accDel);
        	Account deletedAccount = [SELECT Id, IsDeleted FROM Account WHERE Id = :accDel.Id ALL ROWS];
			System.assertEquals(deletedAccount.IsDeleted, true);
        Test.stopTest();   
    }
    @isTest
    private static void updateRecordTest(){
        Profile profile = [select id from Profile where name = 'System Administrator'];
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        User testUser= new User(alias='neUser', email='newTestinguser@test.com', emailencodingkey='UTF-8', lastname='Testing', username='getRecordsTest@test.com',
                                EmployeeNumber='123456780',profileid=profile.id, languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles'); 
        system.runAs(usr){                                             
            insert testUser;
        }
        List<Account> accList = new List<Account>();
        List<Account> accRecs = [SELECT Id From Account WHERE Name LIKE 'Test%']; 
        accRecs[0].Name = 'Test Account Updated 0';
        accRecs[1].Name = 'Test Account Updated 1';
        Boolean isUpdated;
        Test.startTest();
        	isUpdated = LightningDataTableController.updateRecord(accRecs);
        Test.stopTest();   
        Account updatedAccount = [SELECT Id, Name FROM Account WHERE Name = 'Test Account Updated 0' Limit 1];
        System.assertEquals(true,isUpdated);       
    	System.assertEquals(accRecs[0].id, updatedAccount.id);           
    }
}