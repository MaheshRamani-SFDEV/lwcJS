/*  * Test class for Class LC_NoteRecordController 
    *
    * @name           LC_NoteRecordControllerTest 
    * @author         Mahesh Ramani
    * @since          11/27/2019
    * @version        1
    * @Decsription    M11.2019
* */
@isTest
public class LC_NoteRecordControllerTest {    
    public static User thisUser = [SELECT Id from User WHERE Id = :UserInfo.getUserId()];
    @testSetup
    static void setupTestData(){        

        Account testAccount = new Account(Name='TestAccountName') ;
        insert testAccount;
        Profile profile = [select id from Profile where name = 'System Administrator'];
        User testNewUser= new User(alias='neUserq', email='newTestinguser1@test.com');        
        System.RunAs(thisUser){
            insert testNewUser;
        }
    }
    @isTest
    Static void createNoteTest(){
        String userURL= URL.getSalesforceBaseUrl().getHost();
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'TestAccountName' Limit 1];
        User testUser = [SELECT Id FROM User WHERE email='newTestinguser1@test.com' Limit 1];
        Note testNote = creteNoteTestData(testAccount.Id);
        testNote.OwnerId = testUser.Id;
        //Start Test
        Test.startTest();   
        	//create Note
        	System.runAs(testUser){
                String url = LC_NoteRecordController.getURL();            	                
                LC_NoteRecordController.createNoteRecord(testNote);
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
        List<Note> testNotes = createBulkNoteTestData(testAccount.id);
        insert testNotes;
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
    /*This function creates bulk new notes on account record */
    public Static List<Note> createBulkNoteTestData(Id AccountId){
        List<Note> testNoteList = new List<Note>();
        Note testNote1 = new Note();
        testNote1.Title = 'Test Note 1';
        testNote1.Body = 'This is Sample Note 1 for testing of Note View';
        testNote1.IsPrivate = true;
        testNote1.OwnerId = UserInfo.getUserId();
        testNote1.ParentId = AccountId;
        testNoteList.add(testNote1);
        Note testNote2 = new Note();
        testNote2.Title = 'Test Note 2';
        testNote2.Body = 'This is Sample Note 2 for testing of Note View';
        testNote2.IsPrivate = false;
        testNote2.OwnerId = UserInfo.getUserId();
        testNote2.ParentId = AccountId;
        testNoteList.add(testNote2);
        Note testNote3 = new Note();
        testNote3.Title = 'Test Note 3';
        testNote3.Body = 'This is Sample Note 3 for testing of Note View';
        testNote3.IsPrivate = True;
        testNote3.OwnerId = UserInfo.getUserId();
        testNote3.ParentId = AccountId;
        testNoteList.add(testNote3);
        return testNoteList;  
    }
    /*This function creates a new notes on account record */
    public Static Note creteNoteTestData(Id AccountId){
        Note testNote = new Note();
        testNote.Title = 'Create New Test Note';
        testNote.Body = 'This is Sample Note for testing of Note View';
        testNote.IsPrivate = true;
        testNote.OwnerId = UserInfo.getUserId();
        testNote.ParentId = AccountId;
        return testNote;  
    }
}