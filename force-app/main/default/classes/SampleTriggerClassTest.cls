/*  * Test class for Class LC_NoteRecordController 
    *
    * @name           LC_NoteRecordControllerTest 
    * @author         Mahesh Ramani
    * @since          11/27/2019
    * @version        1
    * @Decsription    M11.2019
* */
@isTest
public class SampleTriggerClassTest {    
    public static User thisUser = [SELECT Id from User WHERE Id = :UserInfo.getUserId()];
    @testSetup
    static void setupTestData(){        
        //Test Data using Utility Class
        //TestClassUtil ob = new TestClassUtil();
        //Account testAccount = ob.createClientTestData(testHomeCenter.id);        
        Profile profile = [select id from Profile where name = 'System Administrator'];
        /*User testNewUser= new User(alias='neUserq', email='newTestinguser1@test.com', emailencodingkey='UTF-8', lastname='Testing', username='newTestinguserq1@test.com',
                                    EmployeeNumber='123456780',profileid=profile.id, languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles'
                                    ,Owned__c='Beverage',Owned_Products__c='Foreign Exchange',Product_Home_Center_updated__c=true,User_Type__c='CIB',RACF_ID__c='YOU17');        
        System.RunAs(thisUser){
            insert testNewUser;
        }*/
    }
    @isTest
    Static void createNoteTest(){
        String userURL= URL.getSalesforceBaseUrl().getHost();
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'TestAccountName' Limit 1];
        User testUser = [SELECT Id FROM User WHERE email='newTestinguser1@test.com' Limit 1];
        //TestClassUtil tcu = new TestClassUtil();
        //Note testNote = tcu.creteNoteTestData(testAccount.Id);
       // testNote.OwnerId = testUser.Id;
        //Start Test
        Test.startTest();   
        	//create Note
        	System.runAs(testUser){
                String url = LC_NoteRecordController.getURL();            	                
              //  LC_NoteRecordController.createNoteRecord(testNote);
                System.assertEquals(userURL,url);
                
            }
        Test.stopTest();
        //Stop Test 
        Note note = [SELECT Title, OwnerId FROM Note Where ParentId = :testAccount.id Limit 1];
        System.assertEquals('Create New Test Note',note.Title);
        System.assertEquals(testUser.Id,note.OwnerId);                    
    }
    @isTest
    Static void viewNoteTest(){          
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'TestAccountName' Limit 1];
        User testUser = [SELECT Id FROM User WHERE email='newTestinguser1@test.com' Limit 1];
       // TestClassUtil tcu = new TestClassUtil();
       // List<Note> testNotes = tcu.createBulkNoteTestData(testAccount.id);
       // insert testNotes;
        List<Note> notes;
        //Start Test
        Test.startTest();   
        	//create Note
        	System.runAs(testUser){
            	notes = LC_NoteRecordController.getRelatedNotes(testAccount.id);
            }
        Test.stopTest();
        //List<Note> noteList = [SELECT Title, ParentId FROM Note Where Id = :notes[0].id Limit 1];
        System.assertEquals(3,notes.size());                
        //End Test             
    }
    @isTest static void testIsNoteEnabled() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'TestAccountName' Limit 1];
        User testUser = [SELECT Id FROM User WHERE email='newTestinguser1@test.com' Limit 1];
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        Boolean hasNoteEnabled;
        Test.startTest();   
        	//create Note
        	System.runAs(testUser){
            	hasNoteEnabled = LC_NoteRecordController.isNoteEnabled(testAccount.id);
            }
        Test.stopTest();
        System.assertEquals(true,hasNoteEnabled);
    }
}