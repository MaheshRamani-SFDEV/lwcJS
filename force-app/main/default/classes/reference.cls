//Description of component



//
public class reference{}
/*@isTest(SeeAllData=False)
public class LightningDataTableControllerTest{
    @testSetup
    static void testData(){
        List<Account> accList = new List<Account>();
        for(Integer i= 0;i<100;i++){
        	Account acc = new Account(Name='Test '+i);
            accList.add(acc);
        }
        insert accList;
    }
    @isTest
    private static void getRecordsTest(){
        Profile profile = [select id from Profile where name = 'System Administrator'];
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        User testUser= new User(alias='neUser', email='newTestinguser@test.com', emailencodingkey='UTF-8', lastname='Testing', username='getRecordsTest@test.com',
                                EmployeeNumber='123456780',profileid=profile.id, languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles'); 
        system.runAs(usr){                                             
            insert testUser;
        } 
        List<Account> accRecs = [SELECT Id From Account WHERE Name LIKE 'Test%'];
        LightningDataTableController.DataTableResponse dataTableResponse = new LightningDataTableController.DataTableResponse();          	
        Test.startTest();
        	dataTableResponse = LightningDataTableController.getRecords('Account','dataTableFieldSet','2000');
        Test.stopTest();   
        List<Account> accList = dataTableResponse.lstDataTableData;
        System.assertEquals(accRecs.size(), accList.size());
    }
    
    @isTest
    private static void getURLTest(){
        Profile profile = [select id from Profile where name = 'System Administrator'];
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        User testUser= new User(alias='neUser', email='newTestinguser@test.com', emailencodingkey='UTF-8', lastname='Testing', username='getRecordsTest@test.com',
                                EmployeeNumber='123456780',profileid=profile.id, languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles'); 
        system.runAs(usr){                                             
            insert testUser;
        }
        Test.startTest();
        	LightningDataTableController.getURL();
        Test.stopTest();        
    }
    
	@isTest
    private static void getUIThemeTest(){
        String userTheme;
        Profile profile = [select id from Profile where name = 'System Administrator'];
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        User testUser= new User(alias='neUser', email='newTestinguser@test.com', emailencodingkey='UTF-8', lastname='Testing', username='getRecordsTest@test.com',
                                EmployeeNumber='123456780',profileid=profile.id, languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles'); 
        system.runAs(usr){                                             
            insert testUser;
        }
        Test.startTest();
        	userTheme = LightningDataTableController.getUITheme();
        Test.stopTest(); 
        System.assertEquals('Theme3', userTheme);
    }
    
    @isTest
    private static void deleteRecordTest(){
        Profile profile = [select id from Profile where name = 'System Administrator'];
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        User testUser= new User(alias='neUser', email='newTestinguser@test.com', emailencodingkey='UTF-8', lastname='Testing', username='getRecordsTest@test.com',
                                EmployeeNumber='123456780',profileid=profile.id, languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles'); 
        system.runAs(usr){                                             
            insert testUser;
        } 
        Account accDel = new Account(Name='Test DeleteAccount');
        insert accDel;
        Test.startTest();
        	LightningDataTableController.deleteRecord(accDel);
        	Account deletedAccount = [SELECT Id, IsDeleted FROM Account WHERE Id = :accDel.Id ALL ROWS];
			System.assertEquals(deletedAccount.IsDeleted, true);
        Test.stopTest();   
    }
    @isTest
    private static void updateRecordTest(){
        Profile profile = [select id from Profile where name = 'System Administrator'];
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        User testUser= new User(alias='neUser', email='newTestinguser@test.com', emailencodingkey='UTF-8', lastname='Testing', username='getRecordsTest@test.com',
                                EmployeeNumber='123456780',profileid=profile.id, languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles'); 
        system.runAs(usr){                                             
            insert testUser;
        }
        List<Account> accList = new List<Account>();
        List<Account> accRecs = [SELECT Id From Account WHERE Name LIKE 'Test%']; 
        accRecs[0].Name = 'Test Account Updated 0';
        accRecs[1].Name = 'Test Account Updated 1';
        Boolean isUpdated;
        Test.startTest();
        	isUpdated = LightningDataTableController.updateRecord(accRecs);
        Test.stopTest();   
        Account updatedAccount = [SELECT Id, Name FROM Account WHERE Name = 'Test Account Updated 0' Limit 1];
        System.assertEquals(true,isUpdated);       
    	System.assertEquals(accRecs[0].id, updatedAccount.id);           
    }
}*/

////////////////////////////////////////
//public class LightningDataTableController {
    /*
	Method Name	: getAccRecords
	Purpose		: To get the wrapper of Columns and Headers
	*/
    /*@AuraEnabled
    public static DataTableResponse getRecords(String strObjectName, String strFieldSetName, String numberOfRecords){                
       	//Get the fields from FieldSet
        Schema.SObjectType SObjectTypeObj = Schema.getGlobalDescribe().get(strObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();            
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(strFieldSetName);
        
        //To hold the table hearders 
        List<DataTableColumns> lstDataColumns = new List<DataTableColumns>();
        
        //Field to be queried - fetched from fieldset
        List<String> lstFieldsToQuery = new List<String>();
        
        //Field to be queried - fetched from fieldset
        Map<String, String> lstFieldsToQueryMap = new Map<String, String>();
        
        //The final wrapper response to return to component
        DataTableResponse response = new DataTableResponse();
        
        for( Schema.FieldSetMember eachFieldSetMember : fieldSetObj.getFields() ){
            String dataType = String.valueOf(eachFieldSetMember.getType()).toLowerCase();
            //This way we can set the type of a column
            //We do not get the exact type from schema object which matches to lightning:datatable component structure
            if(dataType == 'datetime'){
                dataType = 'date';
            }
            //Create a wrapper instance and store label, fieldname and type.
            DataTableColumns datacolumns = new DataTableColumns( String.valueOf(eachFieldSetMember.getLabel()) , 
                                                                String.valueOf(eachFieldSetMember.getFieldPath()), 
                                                                String.valueOf(eachFieldSetMember.getType()).toLowerCase(),true,true);
			lstDataColumns.add(datacolumns);
            lstFieldsToQuery.add(String.valueOf(eachFieldSetMember.getFieldPath()));
            lstFieldsToQueryMap.put(String.valueOf(eachFieldSetMember.getFieldPath()),String.valueOf(eachFieldSetMember.getType()));
        }
        List<String> setFields = new List<String>();
        for(String lfqp : lstFieldsToQueryMap.keySet()) {                           

            if(lstFieldsToQueryMap.get(lfqp) == 'reference' && (lfqp.contains('__c'))) {                                         	
            	lfqp = lfqp.removeEnd('__c')+ '__r.Name';
                setFields.add(lfqp); 
            }                     
            else if(lstFieldsToQueryMap.get(lfqp) == 'reference'){ 
                lfqp = lfqp.removeEnd('Id')+ '.Name';
                setFields.add(lfqp); 
            } else{
                setFields.add(lfqp);
            } 
        }
        List<String> setfieldNames = new List<String>();
        for(integer c=0, clang=lstDataColumns.size(); c<clang; c++){                                
                if(lstDataColumns[c].type == 'reference') {                     
                    if(lstDataColumns[c].fieldName.indexOf('__c') == -1) {                     	
                        setfieldNames.add(lstDataColumns[c].fieldName.removeEnd('Id') + '.Name'); 
                        lstDataColumns[c].fieldName = lstDataColumns[c].fieldName.removeEnd('Id') + 'Name'; 
                        lstDataColumns[c].label = lstDataColumns[c].label.removeEnd('ID') + ' Name';
                        lstDataColumns[c].type = 'url';
                        lstDataColumns[c].editable = false;
                    }                     
                    else {                     	
                        setfieldNames.add(lstDataColumns[c].fieldName.removeEnd('__c') + '__r.Name');
                        lstDataColumns[c].type = 'url';
                        lstDataColumns[c].editable = false;
                    }                 
                }else{
                    if(lstDataColumns[c].fieldName == 'Name'){
                        setfieldNames.add(lstDataColumns[c].fieldName);
                        lstDataColumns[c].fieldName = 'link'+lstDataColumns[c].fieldName;
                        lstDataColumns[c].type = 'url';	
                        lstDataColumns[c].editable = false;
                    }else{
                    	setfieldNames.add(lstDataColumns[c].fieldName);
                    }
                }                    
        }         
        system.debug('mahesh:'+setfieldNames);
        //Form an SOQL to fetch the data - Set the wrapper instance and return as response
        if(! lstDataColumns.isEmpty()){  
            response.lstDataTableColumns = lstDataColumns;
            String query = 'SELECT ' + String.join(setfieldNames, ',') + ' FROM '+strObjectName+ ' LIMIT '+numberOfRecords;
            System.debug(query);
            response.lstDataTableData = Database.query(query);
            response.lstFieldsToQuery = setFields;
        }
        return response;
    }
    
    //Wrapper class to hold Columns with headers
    public class DataTableColumns {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled       
        public String fieldName {get;set;}
        @AuraEnabled
        public String type {get;set;}
        @AuraEnabled
        public Boolean sortable {get;set;}
        @AuraEnabled
        public Boolean editable {get;set;}
        
        //Create and set three variables label, fieldname and type as required by the lightning:datatable
        public DataTableColumns(String label, String fieldName, String type, Boolean sortable, Boolean editable){
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;   
            this.sortable = sortable;
            this.editable = editable;
        }
    }
    
    //Wrapper calss to hold response - This response is used in the lightning:datatable component
    public class DataTableResponse {
        @AuraEnabled
        public List<DataTableColumns> lstDataTableColumns {get;set;}
        @AuraEnabled
        public List<sObject> lstDataTableData {get;set;}  
        @AuraEnabled
        public List<String> lstFieldsToQuery {get;set;}  
        
        public DataTableResponse(){
            lstDataTableColumns = new List<DataTableColumns>();
            lstDataTableData = new List<sObject>();
            lstFieldsToQuery = new List<String>();
        }
    }
    
    //get URL  Record
    @AuraEnabled
    public static String getURL(){
        return URL.getSalesforceBaseUrl().getHost();
    }
    
    //Delete Record
    @AuraEnabled
    public static void deleteRecord(sObject record){
        try{
        	Delete record;
        }catch(Exception e){
            //get exception message
            throw new AuraHandledException(e.getMessage());
        }
    }
        
    //update record - Invoke on Inline Edi
    @AuraEnabled
    public static Boolean updateRecord(List<sObject> recordList){
        try {            
            update recordList;  
            return true;                
        }catch(Exception e) {            
            return false;                
        }  
    }
        
   	//user Context UI Theme
    @AuraEnabled
    public static String getUITheme() {
        String theme = UserInfo.getUiThemeDisplayed();
        return theme;
    }
        
}*/


///////////////////////////////////
/*<aura:component implements="flexipage:availableForAllPageTypes" controller="LightningDataTableController">
    
    <aura:attribute name="sObjectName" type="String" default="Opportunity"/>
    <aura:attribute name="fieldSetName" type="String" default="opportunitytable"/>
    <aura:attribute name="numberOfRecord" type="Integer" default="1000"/>
    <aura:attribute name="paginationOffSet" type="Integer" default="5"/>
    <aura:attribute name="numberOfSearchRecord" type="Integer" default="100"/>
    <aura:handler event="force:refreshView" action="{!c.doInit}" />
    
    <aura:attribute name="mydata" type="Object"/>
    <aura:attribute name="mycolumns" type="List"/>

    <aura:attribute name="enableInfiniteLoading" type="Boolean" default="false"/>
    
    <aura:attribute name="url" type="String"/>
    <aura:attribute name="userContext" type="String"/>
    <!-- sorting -->
    <aura:attribute name="sortedBy" type="String"/>
    <aura:attribute name="sortedDirection" type="String"/>
    <aura:attribute name="defaultSortDirection" type="String"/>
    
    <!-- for pagination and sorting -->
    <aura:attribute type="List" name="filteredData" />
    <aura:attribute type="List" name="currentList" />
    <aura:attribute type="Integer" name="pageNumber" default="1" />
    <aura:attribute type="Integer" name="maxPage" default="1" />
    <aura:handler name="change"	value="{!v.pageNumber}"	action="{!c.renderPage}" />
    
    
    <aura:attribute name="lstFieldsToQuery" type="List"/>
 	<aura:attribute name="searchKeyword" type="String" default="" description="use for store user search input"/>
    
    <aura:handler name="init" value="{!this}" action="{!c.doInit}" />   
    <aura:attribute name="Message" type="boolean" default="false" description="use for display no record found message"/>
    
    <div class="slds-box slds-box_small slds-theme_default slds-m-bottom_x-small">
        <div class="slds-grid slds-box slds-box_small slds-theme_shade slds-m-bottom_x-small">                
            <div class="slds-col slds-size_9-of-12">   
                <lightning:icon iconName="standard:search" alternativeText="search" title="search" />
                <b class="slds-p-left_small slds-text-heading_small">{!v.sObjectName} Search Table</b>
                <br/><b>Instruction: </b>Enter Search Keyword for Searching Record in Table...
            </div>  
            <!-- SEARCH INPUT AND SEARCH BUTTON-->           
            <div class="slds-col slds-size_2-of-12 slds-align_left">
                <lightning:input value="{!v.searchKeyword}" required="true" placeholder="search input..." aura:id="searchField" label="Search Keyword"/>
            </div>
            <div class="slds-col slds-size_1-of-12 slds-p-left_x-small slds-align_left">          
                <lightning:button onclick="{!c.handleSearch}" variant="brand" label="Search" iconName="utility:search" class="slds-m-top_large"/> 
            </div>
        </div>
        <div class="slds-box slds-box_small slds-theme_shade slds-m-top_x-small slds-m-bottom_x-small">                      
            <!-- ERROR MESSAGE IF NOT RECORDS FOUND--> 
            <aura:if isTrue="{!v.Message}">
                <div class="slds-notify_container slds-is-relative">
                    <div class="slds-notify slds-notify_toast slds-theme_error" role="alert">
                        <div class="slds-notify__content">
                            <h2 class="slds-text-heading_small">No Records Found...</h2>
                        </div>
                    </div>
                </div>
            </aura:if>
            <div class="slds-grid slds-wrap slds-m-bottom_x-small">
                <lightning:datatable aura:id="searchField"
                                     data="{! v.currentList }" 
                                     columns="{! v.mycolumns }" 
                                     keyField="Id"
                                     hideCheckboxColumn="false"
                                     onrowaction="{!c.handleRowAction}"
                                     sortedBy="{!v.sortedBy}"
                                     sortedDirection="{!v.sortedDirection}"
                                     defaultSortDirection="{!v.defaultSortDirection }"
                                     onsort="{!c.handleColumnSorting}"
                                     onsave="{!c.handleSave }"/>
            </div>
            <aura:if isTrue="{!(v.mydata.length > (v.paginationOffSet))}">
            <lightning:layout  horizontalAlign="center">
                <c:pagination currentPageNumber="{!v.pageNumber}" 
                              maxPageNumber="{!v.maxPage}" />
            </lightning:layout>
        </aura:if>
        </div>
    </div>   
</aura:component>*/

/////////////////////////////////////////
/*({
    doInit : function(component, event, helper) {		                
        helper.fetchURL(component, event, helper);
        helper.fetchUITheme(component, event, helper);
        helper.fetchAction(component, event);
    },     
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        switch (action.name) {
            case 'new':
                helper.createRecord(component, event);
                break;
            case 'edit':
                helper.editRecord(component, event);
                break;
            case 'delete':
                helper.deleteRecord(component, event);
                break;
            case 'view':
                helper.viewRecord(component, event);
                break;
        }
    },    
    handleColumnSorting: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    handleSearch: function(component, event, helper) {
    	helper.searchRecord(component, event, helper);      
    },  
    handleSave: function (component, event, helper) {
        var draftList = event.getParam('draftValues');
        var action = component.get("c.updateRecord");
        action.setParams({
            recordList : draftList
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS" ) {    
                if (response.getReturnValue() === true ) {                   
                	helper.reloadDataTable(component, event, helper);
                }else {                         
                    helper.toastMsg( 'error', 'Something went wrong. Contact your system administrator.' );  
                }  
            }else {  
                helper.toastMsg( 'error', 'Something went wrong. Contact your system administrator.' );  
            }  
        });
        $A.enqueueAction(action);
    },    
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    }
    
})
*/

/////////////////////////
/*
({
    fetchURL : function(component, event, helper) {
        var action = component.get("c.getUITheme");
        action.setCallback(this, function(response){            
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set("v.userContext", response.getReturnValue());
            }else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                }else {
                    helper.toastMsg( 'error',"Unknown error");
                }
            }else{
                helper.toastMsg( 'error', 'Something went wrong, Please check with your admin');
            }
        });
        $A.enqueueAction(action);	
    },
    fetchUITheme : function(component, event, helper) {
        var action = component.get("c.getURL");
        action.setCallback(this, function(response){            
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set("v.url", response.getReturnValue());
                helper.getDataHelper(component, event);
            }else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                }else {
                    helper.toastMsg( 'error',"Unknown error");
                }
            }else{
                helper.toastMsg( 'error', 'Something went wrong, Please check with your admin');
            }
        });
        $A.enqueueAction(action);	
    },

    getDataHelper : function(component, event) {
        var actions = [
            { label: 'New', name: 'new' },
            { label: 'View', name: 'view' },
        	{ label: 'Edit', name: 'edit' },
        	{ label: 'Delete', name: 'delete' }];

        var url = component.get("v.url");
        var userContext = component.get("v.userContext");
        var action = component.get("c.getRecords");
        //Set the Object parameters and Field Set name
        action.setParams({
            strObjectName : component.get("v.sObjectName"),
            strFieldSetName : component.get("v.fieldSetName"),
            numberOfRecords: component.get("v.numberOfRecord")
        });
        action.setCallback(this, function(response){            
            var state = response.getState();
            console.log('state is: '+state);
            if(state === 'SUCCESS'){
                var column = response.getReturnValue().lstDataTableColumns;
                column.forEach(function(column){
                    if(column.type == 'reference' || 'String' ){
                        switch (column.fieldName) {
            			case 'AccountName':
                            column['typeAttributes'] = {label: { fieldName: 'AccountId' }, value:{fieldName: 'AccountName'}, target: '_blank'};
                        	break;
                        case 'OwnerName':
                           column['typeAttributes'] = {label: { fieldName: 'OwnerId' }, value:{fieldName: 'OwnerName'}, target: '_blank'};
                			break;
                        case 'linkName':
                            column['typeAttributes'] = {label: { fieldName: 'Name' }, value:{fieldName: 'linkName'}, target: '_blank'};
                        	break;
            			default:
              				break;
                        }
          			}
                });
                column.push({type: 'action', typeAttributes: { rowActions: actions }, target : '_blank'});
                component.set("v.mycolumns", column);                    
                var data = response.getReturnValue().lstDataTableData;
                data.forEach(function(data){
                    if(userContext =='Theme4t' || 'Theme4d'){
                        if(data.Name != undefined){
                            data.linkName ='https://'+url+'/one/one.app?#/sObject/'+data.Id+'/view';
                        }else{
                            data.linkName = '';
                        }
                        if(data.Account != undefined){   
                            data.AccountName ='https://'+url+'/one/one.app?#/sObject/'+data.AccountId+'/view';
                            data.AccountId = data.Account.Name;
                        }else{
                            data.AccountName='';
                            data.AccountId =''; 
                        }
                        if(data.OwnerId != undefined){
                        	data.OwnerName ='https://'+url+'/one/one.app?#/sObject/'+data.OwnerId+'/view';
                            data.OwnerId = data.Owner.Name;
                        }else{
                            data.OwnerName='';
                            data.OwnerId =''; 
                        }
                    }else if(userContext =='Theme3' ||'Theme2'){
                         if(data.linkName != undefined){
                        	data.linkName = 'https://'+url+'/'+data.Id;
                        }else{
                            data.linkName =''; 
                        }
                        if(data.AccountId != undefined){
                        	data.AccountName = 'https://'+url+'/'+data.Id;
                            data.AccountId = data.Account.Name;
                        }else{
                            data.AccountName='';
                            data.AccountId =''; 
                        }
                        if(data.OwnerId != undefined){
                        	data.OwnerName = 'https://'+url+'/'+data.Id;
                            data.OwnerId = data.Owner.Name;
                        }else{
                            data.OwnerName='';
                            data.OwnerId ='';                            
                        }
                    }
                });  
                component.set("v.mydata", data);
                component.set("v.filteredData", data);   
                if(data.length >0){
                    component.set("v.maxPage", Math.floor((data.length+(component.get("v.paginationOffSet")-1))/component.get("v.paginationOffSet")));
                }
                component.set("v.currentList", data.slice(0,component.get("v.paginationOffSet")));   
                
                component.set("v.lstFieldsToQuery", response.getReturnValue().lstFieldsToQuery);                
            }else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                }else {
                    helper.toastMsg( 'error',"Unknown error");
                }
            }else{
                helper.toastMsg( 'error', 'Something went wrong, Please check with your admin');
            }
        });
        $A.enqueueAction(action);	

    },
    fetchAction : function(component) {
        var actions = [
            {label: 'New', name: 'new'},
            {label: 'Edit', name: 'edit'},
            {label: 'Delete', name: 'delete'},
            {label: 'View', name: 'view'}
        ];
    },

    sortData: function (component, fieldName, sortDirection) {
        var currentList = component.get("v.currentList");
        var reverse = sortDirection !== 'asc';
        currentList.sort(this.sortBy(fieldName, reverse))
        component.set("v.currentList", currentList);
    },
     
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
     
    viewRecord : function(component, event) {
        var row = event.getParam('row');
        var recordId = row.Id;
        var navEvt = $A.get("event.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
     
    deleteRecord : function(component, event) {
        var action = event.getParam('action');
        var row = event.getParam('row');
         
        var action = component.get("c.deleteRecord");
        action.setParams({
            "record": row
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                var rows = component.get('v.mydata');
                var rowIndex = rows.indexOf(row);
                rows.splice(rowIndex, 1);
                $A.get("e.force:refreshView").fire();               
                component.set('v.mydata', rows);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been delete successfully."
                });
                toastEvent.fire(); 
            }else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                }else {
                    helper.toastMsg( 'error',"Unknown error");
                }
            }else{
                helper.toastMsg( 'error', 'Something went wrong, Please check with your admin');
            }

        });
        $A.enqueueAction(action);
    },     
    editRecord : function(component, event) {
        var row = event.getParam('row');
        var recordId = row.Id;
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": recordId
        });
        editRecordEvent.fire();
    },
     
    createRecord : function (component, event) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": component.get("v.sObjectName")
        });
        createRecordEvent.fire();
    },
    renderPage: function(component) {
        var data = component.get("v.mydata"),
        pageNumber = component.get("v.pageNumber"),
        pageRecords = data.slice((pageNumber-1)*component.get("v.paginationOffSet"), pageNumber*component.get("v.paginationOffSet"));
        component.set("v.currentList", pageRecords);
    },
    reloadDataTable : function(component, event, helper){
        component.set("v.searchKeyword", '');                
        var tableRefresh = component.get("c.doInit");
        $A.enqueueAction(tableRefresh);
    	helper.toastMsg(component, 'success', 'Records Saved Successfully.' );
    },
    toastMsg : function(component, strType, strMessage ) {            
        var showToast = $A.get( "e.force:showToast" );   
        showToast.setParams({                 
            message : strMessage,  
            type : strType,  
            mode : 'sticky'                
        });   
        showToast.fire();            
    },
    searchRecord : function(component,event,helper){
        var searchKey = component.get("v.searchKeyword");        			        
    	var data = component.get("v.mydata");
    	if(searchKey.length == 0){
            component.set("v.currentList",data.slice(0, component.get("v.paginationOffSet"))); 
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warninig!",
                    "message": "Please enter search keyword and try again!"
                });
                toastEvent.fire(); 
        }else{
            if(data!=undefined || data.length>0){  
                var filtereddata = data.filter(word => (!searchKey) || word.Name.toLowerCase().indexOf(searchKey.toLowerCase()) > -1);  
                component.set("v.filteredData", filtereddata);
                component.set("v.currentList", filtereddata.slice(0, component.get("v.paginationOffSet"))); 
                if(filtereddata.length >0){
                    component.set("v.maxPage", Math.floor((filtereddata.length+(component.get("v.paginationOffSet")-1))/component.get("v.paginationOffSet")));
                }
        	}
        }
	}
})

///////////////////////////
/*<design:component>
    <design:attribute name="sObjectName" />
    <design:attribute name="fieldSetName"/>
    <design:attribute name="paginationOffSet"/>
    <design:attribute name="numberOfSearchRecord"/>
</design:component>*/