public class display { 
   
    public String country { get; set; }    
    
    public List<selectOption> getPicklistvalues() {
        List<selectOption> options = new List<selectOption>();       
        options.add(new selectOption('India','India'));
        options.add(new selectOption('Australia','Australia'));
        options.add(new selectOption('USA','USA'));
        return options;
    }   

    public Boolean indtf = false;
    public Boolean austf = false;
    public Boolean usatf = false;
       
  
    public void setInd(Boolean b) {
        this.indtf = b;
    }
    public Boolean getInd() {
        return this.indtf;
    }    
    
    
    public void setAus(Boolean b) {
        this.austf = b;
    }
    public Boolean getAus() {
        return this.austf;
    }

    
    public void setUsa(Boolean b) {
        this.usatf = b;
    }
    public Boolean getUsa() {
        return this.usatf;
    }
 
  
    public display() {
        setInd(True);
        setAus(False);
        setUsa(False);
    }
    
    public PageReference selectcountry() {
        if(country == 'Australia') {
            setInd(False);
            setAus(True);
            setUsa(False);
        }
        else if(country == 'USA') {
            setInd(False);
            setAus(False);
            setUsa(True);
        }
        else {
            setInd(True);
            setAus(False);
            setUsa(False);
        }
        return null;
    }
}