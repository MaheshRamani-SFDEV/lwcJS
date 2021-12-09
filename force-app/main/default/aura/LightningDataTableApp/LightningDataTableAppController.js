({
    init: function(component, event, helper) {
        var sample = [];
        // Create 10 random people
        [...Array(10).keys()].forEach(v=>sample.push({name:"Person "+(v+1), age: Math.floor(Math.random()*80)}));
        // initialize data
        component.set("v.columns", [{type:"text",label:"Name",fieldName:"name"},{type:"number",label:"Age",fieldName:"age"}]);
        component.set("v.data", sample);
        component.set("v.filteredData", sample);
    },
    filter: function(component, event, helper) {
        var data = component.get("v.data"),
            term = component.get("v.filter"),
            results = data, regex;
        try {
            regex = new RegExp(term, "i");
            // filter checks each row, constructs new array where function returns true
            results = data.filter(row=>regex.test(row.name) || regex.test(row.age.toString()));
        } catch(e) {
            // invalid regex, use full list
        }
        component.set("v.filteredData", results);
    }
})