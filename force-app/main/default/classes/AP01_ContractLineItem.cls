/*
@author Hoda Ibrahim
@date 28/10/2021
@description: assign only one vehicle/contract to consumer accounts
*/ 
public with sharing class AP01_ContractLineItem {
    public AP01_ContractLineItem() {

    }
    public static void preventConsumerAccountsMultipleContractLineItems(List<ContractLineItem> newContracts){
        try{
            Id consumerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.ConsumerAccountType).getRecordTypeId();
            //non-expired contracts with consumer accounts
            List<ServiceContract> consumerAccountsContracts= [SELECT Id, Name, Account.Id, EndDate, (SELECT Id FROM ContractLineItems) FROM ServiceContract WHERE Account.RecordTypeId=:consumerRecordTypeId AND EndDate>=:Date.today()];
            Map<Id,ServiceContract> consumerAccountsWithContractsMap= new Map<Id,ServiceContract>();//id= servicecontractid
            for(ServiceContract contract:consumerAccountsContracts){
                consumerAccountsWithContractsMap.put(contract.Id,contract);
            }

            system.debug(consumerAccountsWithContractsMap);
            //map for the triggerNew Contract Line items
            Map<Id,ServiceContract> serviceContractForNewContractLineItems= new Map<Id,ServiceContract>();
            Map<Id,ServiceContract> allActiveServiceContracts= new Map<Id,ServiceContract>([SELECT Id, StartDate,EndDate, Account_Type__c FROM ServiceContract]);
            for(Integer i=0;i<newContracts.size();i++){
                system.debug(newContracts[i].ServiceContract.Account_Type__c);
                if(consumerAccountsWithContractsMap.containsKey(newContracts[i].ServiceContractId) && consumerAccountsWithContractsMap.get(newContracts[i].ServiceContractId).ContractLineItems.size()>0){
                    newContracts[i].addError(System.Label.ConsumerAccountMultipleVehicles_ERROR);
                }else if(allActiveServiceContracts.get(newContracts[i].ServiceContractId).Account_Type__c==System.Label.ConsumerAccountType && (allActiveServiceContracts.get(newContracts[i].ServiceContractId).EndDate>=Date.today() )){
                    if(serviceContractForNewContractLineItems.containsKey(newContracts[i].ServiceContractId)){
                        newContracts[i].addError(System.Label.ConsumerAccountMultipleVehicles_ERROR);
                    }else{
                           // If servicecontract.Account_Type__c='Consumer'; triggerNew cant contain two contract line items for this service contract
                        serviceContractForNewContractLineItems.put(newContracts[i].ServiceContractId,allActiveServiceContracts.get(newContracts[i].ServiceContractId));
                    }
                }
            }
        }catch(Exception ex){
            throw ex;
        }
    }
}