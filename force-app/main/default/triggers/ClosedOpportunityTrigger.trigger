trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    List<Task> Ltask = new List<Task>();
    if(Trigger.isInsert){
    	For(Opportunity opp : Trigger.new){
        	if(opp.StageName == 'Closed Won'){
            	Ltask.add(new Task(WhatId = opp.Id,
                               Subject = 'Follow Up Test Task',
                               Priority = 'High',
                               Status = 'In Porgress'));
        	}
   		 }
	}
    if(Trigger.isUpdate){
        For(Opportunity opp : Trigger.new){
            if(opp.StageName == 'Closed Won' && opp.StageName != Trigger.oldMap.get(opp.Id).StageName){
            	Ltask.add(new Task(WhatId = opp.Id,
                               Subject = 'Follow Up Test Task',
                               Priority = 'High',
                               Status = 'In Porgress'));    
            }
        }
    }
    if(Ltask.size()>0){
    	insert Ltask;
	}
}