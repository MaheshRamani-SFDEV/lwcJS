public class contactSetExt {   
    List<Contact> selCon;
    public String Emails = '';
    public contactSetExt(ApexPages.StandardSetController controller) {
        selCon = controller.getSelected(); 
	}
    public pageReference goToHelloWorldPage(){
        if(selCon.isEmpty()){
			//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select atleast one Record to Engage'));
            return null;
        }
        else{
            for ( Contact con : [Select Email From Contact Where Id In :selCon] ){
          		Emails = Emails+con.Email +','; 
        	}
        	Emails = Emails.removeEnd(',');      
            PageReference pageRef = new PageReference('/apex/HelloWorld');
            pageRef.setRedirect(true);
            pageRef.getParameters().put('emails', Emails);
            return pageRef;
        }   
    }
}