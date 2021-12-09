public class dpl {
    
    public String country {get; set;}
    public String state {get; set;}
    
    
    public List<SelectOption> getSelectCountry(){
        List<SelectOption> options = new List<SelectOption>();    
        options.add(new selectOption('None','--- Select Country Name ---'));
        options.add(new selectOption('IN','India'));
        options.add(new selectOption('USA','United State of America'));    
        return options;
    }
    public List<SelectOption> getSelectState(){
       
        List<SelectOption> options = new List<SelectOption>();    
        if(country == 'IN'){
            options.add(new selectOption('GJ','Gujarat'));
            options.add(new selectOption('RJ','Rajsthan'));
            options.add(new selectOption('PJ','Panjab'));    
        }
        else if(country == 'USA'){
            options.add(new selectOption('CO','Colorado'));
            options.add(new selectOption('TX','Texas'));
            options.add(new selectOption('NY','NewYork'));    
        }
        else{
               options.add(new selectOption('None','--- Select ---'));
        }
        return options;
    }
}