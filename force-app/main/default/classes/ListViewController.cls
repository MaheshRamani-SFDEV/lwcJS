public class ListViewController {
    
    @AuraEnabled
    public static list<String> fetchListViews(String strObjName) {
        list<String> lstListViews = new list<String>();
        if(strObjName != null && strObjName !=  ' ' && strObjName.length() != 0) {            
            list<ListView> lstViews = [Select Name,sobjectType From ListView where SobjectType =: strObjName];
            for(ListView iterator:lstViews) {
                lstListViews.add(iterator.Name);
            }
        }   
        return lstListViews;
    }
}