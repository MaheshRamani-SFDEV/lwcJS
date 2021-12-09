public with sharing class SampleTriggerDispatcher implements ITrigger {
/**
 * Class SampleTriggerHandler
 *
 * Trigger Handler for the Account SObject. This class implements the SampleTriggerTriggerInterface
 * interface to help ensure the trigger code is bulkified and all in one place.
 */
	
	// Member variable to hold the Id's of Account 'in use'
	private Set<Id> m_inUseIds = new Set<Id>();
	
	
	// Constructor
	public SampleTriggerDispatcher()
	{
	}
		
    /**
	 * BeforeInsert
	 *
	 * This method is called prior to execution of a BEFORE trigger. Use this to cache
	 * any data required into maps prior execution of the trigger.
	 */
    
    public void beforeInsert(List<SObject> newSObjectList){
        List<Account> newAccountList = (List<Account>) newSObjectList;
        SampleTriggerHelper.beforeInsertHelper(newAccountList);
       }
	/**
	 * beforeUpdate
	 *
	 * This method is called during a BEFORE update trigger.
	 */
	public void beforeUpdate(Map<Id,SObject> newSObjectMap, Map<id,SObject> oldSObjectMap){
        Map<Id,Account> newAccountMap = (Map<Id,Account>)newSObjectMap;
		Map<Id,Account> oldAccountMap = (Map<Id,Account>)oldSObjectMap;
		SampleTriggerHelper.beforeUpdateHelper(newAccountMap, oldAccountMap);   
        }
	
 	
	/**
	 * beforeDelete
	 *
	 * This method is called iteratively for each record to be deleted during a BEFORE
	 * trigger.
	 */
	public void beforeDelete(Map<Id,SObject> oldSObjectMap){
		Map<Id,Account> oldAccountMap = (Map<Id,Account>)oldSObjectMap;
		SampleTriggerHelper.beforeDeleteHelper( oldAccountMap);
	}
	
	public void afterInsert(Map<Id,SObject> newSObjectMap){
        Map<Id,Account> newAccountMap = (Map<Id,Account>)newSObjectMap;
        SampleTriggerHelper.afterInsertHelper(newAccountMap);
	}
	
	/**
	 * afterUpdate
	 *
	 * This method is called AFTER update trigger.
	 */
	public void afterUpdate(Map<Id,SObject> newSObjectMap, Map<id,SObject> oldSObjectMap){
       Map<Id,Account> newAccountMap = (Map<Id,Account>)newSObjectMap;
		Map<Id,Account> oldAccountMap = (Map<Id,Account>)oldSObjectMap;
        SampleTriggerHelper.afterUpdateHelper(newAccountMap, oldAccountMap);
	}
	
	/**
	 * afterDelete
	 *
	 * This method is called This method is called AFTER delete trigger.
	 */
	public void afterDelete(Map<Id,SObject> oldSObjectMap){
        Map<Id,Account> oldAccountMap = (Map<Id,Account>)oldSObjectMap;
		SampleTriggerHelper.afterDeleteHelper(oldAccountMap);
	}
	
	/**
	 * afterUnDelete
	 *
	 * This method is called AFTER unupdate trigger.
	 */
	public void afterUndelete(Map<Id,SObject> newSObjectMap){
		 Map<Id,Account> newAccountMap = (Map<Id,Account>)newSObjectMap;
        SampleTriggerHelper.AfterUndeleteHelper(newAccountMap);
	}
	
	

}