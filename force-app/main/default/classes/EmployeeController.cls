public with sharing class  EmployeeController {
 
    @AuraEnabled
    public static Employee__c save(Employee__c employee){
       	Employee__c emp = employee;
        if(emp == null)
           throw new AuraHandledException('employee is null');
        insert emp;
        return emp;
    }
    
    @AuraEnabled
    public static List<Employee__c> getAllEmployees(){
        List<Employee__c> employeeList = [select Id, Name, Age__c, Department__c from Employee__c order by Id desc limit 20];
        return employeeList;
    }
}