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