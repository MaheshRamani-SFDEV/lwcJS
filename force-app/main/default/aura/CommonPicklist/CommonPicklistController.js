({
  doInit: function(component, event, helper) {
        helper.fetchTypePicklist(component); // fetches PickList Values of Type Field
        helper.fetchStagePicklist(component); // fetches PickList Values of Stage Field
        helper.fetchLeadSourcePicklist(component); // fetches PickList Values of LeadSource Field
    },
})