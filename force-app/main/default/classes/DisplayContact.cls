public with sharing class DisplayContact {
    public List<Contact> conList {get;set;}
    public DisplayContact(ApexPages.StandardSetController controller) {
        controller.setpagesize(5);
    }
       
    public PageReference ContactLists()
    {
        IF(ApexPages.currentPage().getParameters().get('id') != null)
            conList = [Select id,Name,Phone,Email from contact where accountId =: ApexPages.currentPage().getParameters().get('id')];
        return null;
    }   
    
    
}