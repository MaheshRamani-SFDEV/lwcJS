public with sharing class displaycon {
    
    public List<Contact> conList {get;set;}
    public displaycon(ApexPages.StandardSetController controller) {
        controller.setpagesize(10);
    }
public PageReference ContactLists(){
        PageReference pr = Page.accountDisplay;
            if(ApexPages.currentPage().getParameters().get('id') != null)
                conList = [Select id,Name,Phone,Email from contact where accountId =: ApexPages.currentPage().getParameters().get('id')];
        pr.setRedirect(true);
        return pr;
}
}