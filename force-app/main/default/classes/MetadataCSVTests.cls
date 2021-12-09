@isTest
public class MetadataCSVTests {
    @istest
    static void testFetchMetaData() {
        String fieldId = '\'00N80000004ze2M\'';
        Test.startTest();
        list <Object> objectList = MetadataCSV.fetchMetaData(fieldId);
        Test.stopTest();
        System.assertEquals(5, objectList.size(),'Dependencies must be returned');
    }
}