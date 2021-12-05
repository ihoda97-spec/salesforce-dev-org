public class ContactTriggerHandler extends TriggerHandler implements ITriggerHandler{
    private Map<Id, Contact> newMap;
    private Map<Id, Contact> oldMap;
    private List<Contact> triggerNew;
    private List<Contact> triggerOld;
    public ContactTriggerHandler() {
        this.newMap = (Map<Id, Contact>) Trigger.newMap;
        this.oldMap = (Map<Id, Contact>) Trigger.oldMap;
        this.triggerNew= (List<Contact>) Trigger.New;
        this.triggerOld= (List<Contact>) Trigger.Old;

    }
    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled(){
        return TriggerDisabled;
    }

    public override void beforeInsert() {
        try{
            
            //ConsumerAccountTriggerHelper.preventConsumerAccountMultipleContacts(triggerOld, triggerNew);
            AP01_Contact.preventConsumerAccountMultipleContacts(triggerOld, triggerNew);
            
        }catch(Exception ex){
            throw ex;
        }
    }

    public override void afterInsert() {}

    public override void beforeUpdate() {
        try{
            AP01_Contact.preventConsumerAccountMultipleContacts(triggerOld, triggerNew);
            //ConsumerAccountTriggerHelper.preventConsumerAccountMultipleContacts(triggerOld, triggerNew);
        }catch(Exception ex){
            throw ex;
        }
    }

    public override void afterUpdate() {
        // try{
        //     ContactTriggerHandlerHelper.preventConsumerAccountMultipleContacts(triggerOld, triggerNew);
        // }catch(Exception ex){
        //     throw ex;
        // }
    }

    public override void beforeDelete() {}

    public override void afterDelete() {}

 public override void afterUnDelete() {}
}