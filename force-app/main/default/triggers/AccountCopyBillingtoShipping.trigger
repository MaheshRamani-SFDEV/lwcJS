trigger AccountCopyBillingtoShipping on Account (Before insert, Before update) {
    for (account accId : Trigger.new){
        if (accId.Copy_Address__C == True){
            accId.ShippingState = accId.BillingState;
            accId.ShippingStreet = accId.BillingStreet;
            accId.ShippingCity = accId.BillingCity;
            accId.ShippingPostalCode = accId.BillingPostalCode;
            accId.ShippingCountry = accId.BillingCountry;  
        }
    }
}