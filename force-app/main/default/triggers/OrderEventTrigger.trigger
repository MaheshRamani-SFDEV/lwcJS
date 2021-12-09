trigger OrderEventTrigger on Order_Event__e (after insert) {
	
    List<Task> tasks = new List<Task>();
    
    User myUser = [SELECT Id FROM User WHERE Name='Mahesh Ramani' LIMIT 1];

    for(Order_Event__e event : Trigger.new){
    	if(event.Has_Shipped__c == true){
    		Task t = new Task();
            
            t.Priority = 'Medium';
            t.Status = 'New';
            t.Subject = 'Follow up on shipped order '+event.Order_Number__c;
            t.OwnerId = myUser.Id;
            tasks.add(t);    
    	}
    }
    insert tasks;
}