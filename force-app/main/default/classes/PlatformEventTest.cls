@isTest
public class PlatformEventTest{
    @isTest
    static void test(){
    	Order_Event__e  orderEvent = new Order_Event__e(Order_Number__c='105', Has_Shipped__c=true);
		
        Test.startTest();
        Database.saveResult sr = EventBus.publish(orderEvent);	
		test.stoptest();
        
        if(sr.isSuccess()){
    		System.debug('event successfully published');
		}else{
    		for(Database.Error er : sr.getErrors()){
	    		System.debug('error is: '+ er.getStatusCode()+'and'+er.getMessage());
    		}
		}    
    }
}