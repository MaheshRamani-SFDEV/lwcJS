/**
 *Interface -Template Design pattern for Triggers .
  Description: Interface containing methods Trigger Handlers must implement to enforce best practice and bulkification of triggers.
 */
public interface ITrigger 
{
	/**
	 * BeforeInsert
	 *
	 * This method is called prior to execution of a BEFORE trigger. Use this to cache
	 * any data required into maps prior execution of the trigger.
	 */
	void beforeInsert(List<SObject> newSObject);

	
	/**
	 * beforeUpdate
	 *
	 * This method is called during a BEFORE update trigger.
	 */
	void beforeUpdate(Map<Id,SObject> newSObjectMap, Map<id,SObject> oldSObjectMap);

	/**
	 * beforeDelete
	 *
	 * This method is called during a BEFORE delete trigger.
	 */
	void beforeDelete(Map<Id,SObject> oldSObjectMap);

	/**
	 * afterInsert
	 *
	 * This method is called during AFTER insert trigger. Always put field validation in the 'After' methods in case another trigger
	 * has modified any values. The record is 'read only' by this point.
	 */
	void afterInsert(Map<Id,SObject> newSObjectMap);

	/**
	 * afterUpdate
	 *
	 * This method is called AFTER update trigger.
	 */
	void afterUpdate(Map<Id,SObject> newSObjectMap, Map<id,SObject> oldSObjectMap);

	/**
	 * afterDelete
	 *
	 * This method is called This method is called AFTER delete trigger.
	 */
	void afterDelete(Map<Id,SObject> oldSObjectMap);
	
	/**
	 * afterUnDelete
	 *
	 * This method is called AFTER unupdate trigger.
	 */
	void afterUndelete(Map<Id,SObject> newSObjectMap);

}