({
	getRecordView : function(component, selectedRecord) {
		var selectedRecord = component.get("v.selectedRecord");//get account list
        component.set("v.selectedRecord", selectedRecord); //refresh accountlist
    }
})