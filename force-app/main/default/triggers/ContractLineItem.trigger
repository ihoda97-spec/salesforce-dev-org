trigger ContractLineItem on ContractLineItem(before insert, after insert, before update, after update, before delete, after
delete, after unDelete) {
    new ContractLineItemTriggerHandler().run();
}