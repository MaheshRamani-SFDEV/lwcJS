<aura:application  access="GLOBAL" extends="ltng:outApp" >
  <aura:dependency resource="customLeadContainer"/> //dependency is not declared-->

    <aura:dependency resource="markup://force:*" type="EVENT"/>
    <aura:dependency resource="markup://force:showToast" type="EVENT"/>
</aura:application>