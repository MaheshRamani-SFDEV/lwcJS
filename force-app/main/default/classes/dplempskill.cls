public class dplempskill {
    
    public String employee {get; set;}
    public String skill {get; set;}
    
   
    public List<SelectOption> getSelectEmployee(){
        List<SelectOption> options = new List<SelectOption>();    
        options.add(new selectOption('None','--- Select Employee Name ---'));
        options.add(new selectOption('MR','Mahesh Ramani'));
        options.add(new selectOption('SG','Suraj Gupta')); 
        options.add(new selectOption('PP','Piyush Pranav'));
        options.add(new selectOption('RK','Ruchika Khandelwal'));   
        return options;
    }
    public List<SelectOption> getSelectSkill(){
       
        List<SelectOption> options = new List<SelectOption>();    
        if(employee == 'MR'){
            options.add(new selectOption('MF','Mainframe'));
            options.add(new selectOption('SDEV','Salesforce Dev')); 
            options.add(new selectOption('SADM','Salesforce AdM'));
            options.add(new selectOption('JV','Java'));    
        }
        else if(employee == 'PP'){
            options.add(new selectOption('SDEV','Salesforce Dev'));
            options.add(new selectOption('SADM','Salesforce ADM'));    
        }
        else if(employee == 'RK'){
            options.add(new selectOption('INF','Informatica'));
            options.add(new selectOption('MF','Mainframe'));    
        }
        else if(employee == 'SG'){
            options.add(new selectOption('JV','JAVA'));
            options.add(new selectOption('AG','Angular'));       
        }
        else{
            options.add(new selectOption('None','--- Select Skill ---'));
        }
        return options;
    }
}