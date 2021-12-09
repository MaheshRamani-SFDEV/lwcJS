public class displayinfo{
        
    public Boolean Personal = false;
    public Boolean Company = false;
    public Boolean Spaces = false; 
    public String UserName {get; set;}
    
    public List<selectOption> getPicklistvalues(){
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption(' ',' '));
        options.add(new selectOption('Mahesh','Mahesh'));
        options.add(new selectOption('Raja','Raja'));
        return options;
    }
    public displayinfo(){
        setPersonal(false);
        setCompany(false);
    }
    public void displayinfo(Boolean s){
        setPersonal(s);
        setCompany(s);
    }
 
    public void setPersonal(Boolean p){
        this.Personal = p;
    }   
    public Boolean getPersonal(){
        return this.Personal;
    }
    public void setCompany(Boolean c){
        this.Company = c;
    }
    public Boolean getCompany(){
        return this.Company;
    }
    public Pagereference selectUserName(){
    
        if(UserName == 'Mahesh'){
            setPersonal(true);
            setCompany(false);
        }
        else if(UserName == 'Raja'){
            setPersonal(false);
            setcompany(true);
        }
        else{
            displayinfo(Spaces);
        }
        return null;
    }

}