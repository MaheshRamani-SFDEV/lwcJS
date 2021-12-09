//Trigger Framwork Classes: --> http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/
//1. ITriggerHandler
//2. TriggerDispatcher
//3. AccountTriggerHandler 
//4. AccountTrigger
public interface ITriggerHandler 
{
    void BeforeInsert(List<SObject> newItems);
 
    void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems);
 
    void BeforeDelete(Map<Id, SObject> oldItems);
 
    void AfterInsert(Map<Id, SObject> newItems);
 
    void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems);
 
    void AfterDelete(Map<Id, SObject> oldItems);
 
    void AfterUndelete(Map<Id, SObject> oldItems);
 
    Boolean IsDisabled();
}