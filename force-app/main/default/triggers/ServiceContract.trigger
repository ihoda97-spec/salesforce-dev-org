trigger ServiceContract on ServiceContract(before insert, after insert, before update, after update, before delete, after
delete, after unDelete) {
    new ServiceContractTriggerHandler().run();
}