global class MyCustomPickList extends VisualEditor.DynamicPickList{
    global override VisualEditor.DataRow getDefaultValue(){
    	VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('red', 'RED');
   		return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DataRow value1 = new VisualEditor.DataRow('red', 'RED');
        VisualEditor.DataRow value2 = new VisualEditor.DataRow('yellow', 'YELLOW');       
        VisualEditor.DataRow value3 = new VisualEditor.DataRow('pink', 'PINK');
        VisualEditor.DataRow value4 = new VisualEditor.DataRow('brown', 'BROWN');
        VisualEditor.DataRow value5 = new VisualEditor.DataRow('black', 'BLACK');
        VisualEditor.DynamicPickListRows myValues = new VisualEditor.DynamicPickListRows();
        
        myValues.addRow(value1);
        myValues.addRow(value2);
       	myValues.addRow(value3);
        myValues.addRow(value4);
        myValues.addRow(value5);
        return myValues;
    }
}