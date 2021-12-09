({
     handleUploadFinished : function(cmp, event, helper) {
         var uploadedFiles=event.getParam('files');
         console.log('Files uploaded: '+JSON.stringify(uploadedFiles));
         var fileIds=[];
         uploadedFiles.forEach(function(file){
             fileIds.push(file.documentId);
         });
         cmp.set('v.fileIds', fileIds);
     },       
    setRecordId: function(cmp, event, helper){
        var employeeId = event.getParam('employeeId');
        console.log('employee Id received: '+ employeeId);
        cmp.set('v.recordId', employeeId);
    }
})