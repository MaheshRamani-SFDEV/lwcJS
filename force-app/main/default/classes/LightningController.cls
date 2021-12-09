public class LightningController {
    @AuraEnabled
    public static Map < String, String > fetchMapData() {
        Map < String, String > mapCustomer = new Map < String, String >();
        mapCustomer.put('Sample', 'Value');
        mapCustomer.put('Sample1', 'Value1');
        mapCustomer.put('Sample2', 'Value2');
        mapCustomer.put('Sample3', 'Value3');
        system.debug(mapCustomer);         
        return mapCustomer;
    }
}