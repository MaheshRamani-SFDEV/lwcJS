public class AttributeController {
    //private final String[] nameString;
    @AuraEnabled
    public static List<String> getNameArray(){
        String[] nameString = new String[]{'Raja', 'OM', 'Siddik'};
        return nameString;
    }
}