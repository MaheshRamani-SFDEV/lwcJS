@isTest
public class TestOpportunityChangeTrigger {
    @isTest 
    static void testCreateAndUpdateOpportunity(){
        // Enable all Change Data Capture entities for notifications.
        Test.enableChangeDataCapture(); 
        // Insert an Opportunity test record
        insert new Opportunity(Name= 'Sell 100 Widgets', 
                               StageName= 'Prospecting',
                               CloseDate= Date.today().addMonths(3)); 
        // Call deliver to fire the trigger and deliver the test change event.
        Test.getEventBus().deliver();
        // Update opportunity record
        Opportunity[] oppRecords = [SELECT Id,StageName FROM Opportunity];
        // There is only one test record, so get the first one
        Opportunity opp = oppRecords[0];
        // Debug
        System.debug('Retrieved Opportunity record: ' + opp);
        // Update one field and empty another
        opp.StageName = 'Closed Won';
        update opp;
        // Call deliver to fire the trigger for the update operation.
        Test.getEventBus().deliver();
        // VERIFICATIONS
        // Check that the change event trigger created a task.
        // We should have two tasks now, including one from the first trigger invocation.
        Task[] taskList2 = [SELECT Id,Subject FROM Task]; 
        System.assertEquals(3, taskList2.size(),
                            'The change event trigger did not create the expected task.');
    }
}