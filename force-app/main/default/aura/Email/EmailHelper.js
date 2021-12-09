({
    /*
    This helper function filters emails from objects.
    */
    filterEmails : function(people){
    	return this.getEmailsFromList(people.to).concat(this.getEmailsFromList(people.cc));
    },
    getEmailsFromList : function(list){
        var ret = [];
        for (var i in list) {
        	ret.push(list[i].email);
        }
        return ret;
    }
})