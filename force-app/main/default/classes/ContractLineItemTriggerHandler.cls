public with sharing class ContractLineItemTriggerHandler extends TriggerHandler implements ITriggerHandler{
    private Map<Id, ContractLineItem> newMap;
    private Map<Id, ContractLineItem> oldMap;
    private List<ContractLineItem> triggerNew;
    private List<ContractLineItem> triggerOld;
    public ContractLineItemTriggerHandler() {
        this.newMap = (Map<Id, ContractLineItem>) Trigger.newMap;
        this.oldMap = (Map<Id, ContractLineItem>) Trigger.oldMap;
        this.triggerNew= (List<ContractLineItem>) Trigger.New;
        this.triggerOld= (List<ContractLineItem>) Trigger.Old;

    }
    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled(){
        return TriggerDisabled;
    }

    public override void beforeInsert() {
        try{
            //ConsumerAccountTriggerHelper.preventConsumerAccountsMultipleContractLineItems(triggerNew);
            AP01_ContractLineItem.preventConsumerAccountsMultipleContractLineItems(triggerNew);
        }catch(Exception ex){
            throw ex;
        }
    }

    public override void afterInsert() {}

    public override void beforeUpdate() {}

    public override void afterUpdate() {}

    public override void beforeDelete() {}

    public override void afterDelete() {}

    public override void afterUnDelete() {}
}