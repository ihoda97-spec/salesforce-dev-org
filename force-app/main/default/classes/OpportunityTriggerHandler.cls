public with sharing class OpportunityTriggerHandler extends TriggerHandler implements ITriggerHandler{
    private Map<Id, Opportunity> newMap;
    private Map<Id, Opportunity> oldMap;
    private List<Opportunity> triggerNew;
    private List<Opportunity> triggerOld;
    public OpportunityTriggerHandler() {
        this.newMap = (Map<Id, Opportunity>) Trigger.newMap;
        this.oldMap = (Map<Id, Opportunity>) Trigger.oldMap;
        this.triggerNew= (List<Opportunity>) Trigger.New;
        this.triggerOld= (List<Opportunity>) Trigger.Old;

    }
    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled(){
        return TriggerDisabled;
    }

    public override void beforeInsert() {

    }

    public override void afterInsert() {}

    public override void beforeUpdate() {}

    public override void afterUpdate() {
        try{
            AP01_Opportunity.createContractsForOpportunitiesWithStageCloseWon(oldMap, newMap);
            
        }catch(Exception ex){
            throw ex;
        }
    }

    public override void beforeDelete() {}

    public override void afterDelete() {}

 public override void afterUnDelete() {}
}