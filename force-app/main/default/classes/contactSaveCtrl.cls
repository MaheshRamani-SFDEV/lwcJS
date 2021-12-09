public class contactSaveCtrl {
 @AuraEnabled 
    public static void saveContact(Contact con){
        insert con;
    }   
}