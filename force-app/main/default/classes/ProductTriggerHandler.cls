public with sharing class ProductTriggerHandler extends TriggerHandler implements ITriggerHandler{
    private Map<Id, Product2> newMap;
    private Map<Id, Product2> oldMap;
    private List<Product2> triggerNew;
    private List<Product2> triggerOld;
    public ProductTriggerHandler() {
        this.newMap = (Map<Id, Product2>) Trigger.newMap;
        this.oldMap = (Map<Id, Product2>) Trigger.oldMap;
        this.triggerNew= (List<Product2>) Trigger.New;
        this.triggerOld= (List<Product2>) Trigger.Old;

    }
    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled(){
        return TriggerDisabled;
    }

    public override void beforeInsert() {

    }

    public override void afterInsert() {}

    public override void beforeUpdate() {}

    public override void afterUpdate() {}

    public override void beforeDelete() {}

    public override void afterDelete() {}

 public override void afterUnDelete() {}
}