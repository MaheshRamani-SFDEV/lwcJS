/*  * Trigger ClientCoverageTrigger - 
    * @name           ClientCoverageTrigger 
    * @author         Mahesh Ramani
    * @since          11/13/2019
    * @version        1.0
    * @Decsription    M11.2019
*/ 
trigger SampleTrigger on Account (before insert , before update , before delete ,
                                             after insert , after update , after delete , after Undelete)
{
    if(!SampleTriggerHelper.isTriggerBypassed()){
        system.debug(LoggingLevel.DEBUG, 'Coverage Team Trigger -->Before');
        TriggerFactory.createDispatcher(Account.sObjectType);
        system.debug(LoggingLevel.DEBUG, 'Coverage Team Trigger -->After');
    }                                           
    
}