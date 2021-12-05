public with sharing class ServiceContractTriggerHandler extends TriggerHandler implements ITriggerHandler{
    private Map<Id, ServiceContract> newMap;
    private Map<Id, ServiceContract> oldMap;
    private List<ServiceContract> triggerNew;
    private List<ServiceContract> triggerOld;
    public ServiceContractTriggerHandler() {
        this.newMap = (Map<Id, ServiceContract>) Trigger.newMap;
        this.oldMap = (Map<Id, ServiceContract>) Trigger.oldMap;
        this.triggerNew= (List<ServiceContract>) Trigger.New;
        this.triggerOld= (List<ServiceContract>) Trigger.Old;

    }
    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled(){
        return TriggerDisabled;
    }

    public override void beforeInsert() {
        try{    
            //ConsumerAccountTriggerHelper.preventConsumerAccountMultipleServiceContracts(triggerOld, triggerNew);
            AP01_ServiceContract.preventConsumerAccountMultipleServiceContracts(triggerOld, triggerNew);
        }catch(Exception ex){
            throw ex;
        }
    }

    public override void afterInsert() {}

    public override void beforeUpdate() {
        try{    
            //ConsumerAccountTriggerHelper.preventConsumerAccountMultipleServiceContracts(triggerOld, triggerNew);
            AP01_ServiceContract.preventConsumerAccountMultipleServiceContracts(triggerOld, triggerNew);
        }catch(Exception ex){
            throw ex;
        }
    }

    public override void afterUpdate() {
        // try{    
        //     ContactTriggerHandlerHelper.preventConsumerAccountMultipleServiceContracts(triggerOld, triggerNew);
        // }catch(Exception ex){
        //     throw ex;
        // }
    }

    public override void beforeDelete() {}

    public override void afterDelete() {}

    public override void afterUnDelete() {}
}