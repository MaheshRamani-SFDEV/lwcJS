({
    handleUpdateRaces : function(component, event, helper) {
    console.log("calling updateRaces in ListRaceController");
    var race = event.getParam("race");
    var races = component.get("v.races");
    races.push(race);
    component.set("v.races", races);
	}
})