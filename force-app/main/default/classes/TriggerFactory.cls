/**
 * Class TriggerFactory
  Description: Used to instantiate and execute Trigger Dispatchers associated with sObjects.
  Version : Salesforce.comApi 45
 */
public with sharing class TriggerFactory
{
	/**
	 * Public static method to create and execute a trigger Dispatcher
	 *
	 * Arguments:	Schema.sObjectType soType - Object type to process (SObject.sObjectType)
	 *
	 * Throws a TriggerException if no Dispatcher has been coded.
	 */
	public static void createDispatcher(Schema.sObjectType soType)
	{
		// Get a Dispatcher appropriate to the object being processed
		ITrigger dispatcher = getDispatcher(soType);
		
		// Make sure we have a Dispatcher registered, new Dispatchers must be registered in the getDispatcher method.
		if (dispatcher == null)
		{
			return;
			//throw new TriggerException('No Trigger Dispatcher registered for Object Type: ' + soType);
		}
		
		// Execute the Dispatcher to fulfil the trigger
		System.debug(soType + ': CPU LIMIT AFTER=>START ' + LimitS.getCpuTime());
		execute(dispatcher);
		System.debug(soType + ': CPU LIMIT AFTER=>END ' + LimitS.getCpuTime());   
	}
	
	/**
	 * private static method to control the execution of the Dispatcher
	 *
	 * Arguments:	ITrigger Dispatcher - A Trigger Dispatcher to execute
	 */	
	private static void execute(ITrigger dispatcher)
	{
		// Before Trigger
		if (Trigger.isBefore)
		{
			// Call the bulk before to handle any caching of data and enable bulkification
			if(trigger.isInsert){
				dispatcher.beforeInsert(trigger.new);
			}
			else if(trigger.isUpdate){
				dispatcher.beforeUpdate(trigger.newMap, trigger.oldMap);
			}
			else if(trigger.isDelete){
				dispatcher.beforeDelete(trigger.oldMap);
			}
		}
		// Before Trigger
		else if (Trigger.isAfter)
		{
			// Call the bulk before to handle any caching of data and enable bulkification
			if(trigger.isInsert){
				dispatcher.afterInsert(trigger.newMap);
			}
			else if(trigger.isUpdate){
				dispatcher.afterUpdate(trigger.newMap, trigger.oldMap);
			}
			else if(trigger.isDelete){
				dispatcher.afterDelete(trigger.oldMap);
			}
			else if(trigger.isUndelete){
				dispatcher.afterUndelete(trigger.newMap);
			}
		}					
	} //End of execute method
	
	/**
	 * private static method to get the appropriate Dispatcher for the object type.
	 * Modify this method to add any additional Dispatchers.
	 *
	 * Arguments:	Schema.sObjectType soType - Object type tolocate (SObject.sObjectType)
	 *
	 * Returns:		ITrigger - A trigger Dispatcher if one exists or null.
	 */
	private static ITrigger getDispatcher(Schema.sObjectType soType)
	{
		// Standard Objects in alphabetical order
		if (soType == Account.sObjectType)
		{
			//return new SampleTriggerDispatcher();
		}
		else if (soType == Case.sObjectType)
		{
			//return new CaseTriggerDispatcher();
		}
		return null;
	}
}