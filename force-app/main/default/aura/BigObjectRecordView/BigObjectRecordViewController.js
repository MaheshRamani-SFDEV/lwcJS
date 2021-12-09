({
	recordView : function(component, event, helper) {
		var selectedRecord = event.getParam("selectedRecord");//get attribute param from event
        helper.getRecordView(component, selectedRecord);//get data from the helper
	}
})