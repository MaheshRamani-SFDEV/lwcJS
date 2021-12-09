@isTest
public class BigObjectUtilityControllerTest {
    
    private static final String objlabel = 'Customer Interactions';
    private static final String apiname = 'Customer Interaction__b';
	private static final String objvalue = 'Customer_Interaction__b';
    
    
    @isTest static void TestIndFields(){
       
        List<wrapFields> objList = new List<wrapFields>();

        Test.startTest();
        //objList = BigObjectUtilityController.getIndFields(objvalue);
        Test.stopTest();
        
        System.assertEquals(objList[0].label, apiname);  
        System.assertEquals(objList[0].value, objvalue);          
    }
        public class wrapFields implements Comparable {
            public String label;
            public String value;
            public String objDT;
            public wrapFields(String objlabel,String apiname, String objDataType){
                this.label = objlabel;
                this.value = apiname;
                this.objDT = objDataType;
            }        
                public Integer compareTo(Object compareTo) {
                wrapFields compareToEmp = (wrapFields)compareTo;
                if (value == compareToEmp.value) return 0;
                if (value > compareToEmp.value) return 1;
                return -1;        
            } 
    }
    	
	/*private static final String expectedAccount__c = '0017F00001YAQOmQAP';
	private static final String expectedGame_Platform__c = 'Platform 10';
	private static final DateTime expectedPlay_Date__c = DateTime.newInstance(2019, 3, 15);
    private static final String expectedIn_Game_Purchase__c = 'A12345';
    private static final String expectedLevel_Achieved__c = '45';
    private static final String expectedLives_This_Game__c = '3';
    private static final String expectedScore_This_Game__c = '5500';
    private static final Integer expectedPlay_Duration__c = 25;
    
	private static final String whereClause = '';
    private static final List<String> selColumns = {};
    
    @isTest static void TestBigOData(){
 
        Test.startTest();
        DataTableResponse response = BigObjectUtilityController.getBigOData(String objvalue, String whereClause, List<String> selColumns);
		Test.stopTest();

        System.assertEquals(response.lstDataTableData[0].Account__c, expectedAccount__c);
        System.assertEquals(response.lstDataTableData[0].Game_Platform__c, expectedGame_Platform__c);
        System.assertEquals(response.lstDataTableData[0].Play_Date__c, expectedPlay_Date__c);
        System.assertEquals(response.lstDataTableData[0].In_Game_Purchase__c, expectedIn_Game_Purchase__c); 
        System.assertEquals(response.lstDataTableData[0].Level_Achieved__c, expectedLevel_Achieved__c );
        System.assertEquals(response.lstDataTableData[0].Lives_This_Game__c, expectedLives_This_Game__c);
        System.assertEquals(response.lstDataTableData[0].Play_Duration__c, expectedScore_This_Game__c);
        System.assertEquals(response.lstDataTableData[0].Score_This_Game__c, expectedPlay_Duration__c);  
    }*/
}