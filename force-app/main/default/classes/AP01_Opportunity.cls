/*
@author Hoda Ibrahim
@date 28/10/2021
@description: automatically create an account when an opportunity is won
*/ 
public with sharing class AP01_Opportunity {
    public AP01_Opportunity() {

    }
    public static void createContractsForOpportunitiesWithStageCloseWon(Map<Id,Opportunity> oldMap, Map<Id,Opportunity> newMap){
        try{
            Map<Id,ServiceContract> contractsToBeInserted = new Map<Id,ServiceContract>();//id=opportunity id
            List<Id> contractsToBeInsertedPriceBookIds= new List<Id>();
            //perform trigger logic only if opportunity stage is won
            boolean trig=false;
            for(Id id:newMap.keySet()){
                Opportunity newOpp= newMap.get(id);
                Opportunity oldOpp= oldMap.get(id);
                
                if(oldOpp.StageName != newOpp.StageName && newOpp.StageName==System.label.OpportunityStageWon){
                    system.debug('opportunity');
                    system.debug(newOpp);
                    trig=true;
                    //create service contract
                    ServiceContract contract = new ServiceContract();
                    contract.AccountId=newOpp.AccountId;
                    contract.PriceBook2Id=newOpp.Pricebook2Id;
                    contract.Name=newOpp.Name+' Contract';
                    //contract.StartDate= newOpp.CloseDate;
                    contract.StartDate=newOpp.Contract_Start_Date__c;
                    contract.EndDate=newOpp.Contract_End_Date__c;
                    contractsToBeInserted.put(newOpp.Id,contract);
                    contractsToBeInsertedPriceBookIds.add(newOpp.Pricebook2Id);
                }
            }
            if(trig){
                if(contractsToBeInserted.size()>0){
                    insert contractsToBeInserted.values();// insert service contract
                }
                Map<Id,Decimal> productPrices= new Map<Id,Decimal>();// id is product2id
                Map<Id,Id> productOpportunities= new Map<Id,Id>(); //key = ProductId, value=OpportunityId
                List<OpportunityLineItem> opportunities=[SELECT OpportunityId, Product2Id, ListPrice FROM OpportunityLineItem WHERE OpportunityId=:newMap.keySet()];
                
                    for(OpportunityLineItem opportunity: opportunities){
                        // add products and prices
                        productPrices.put(opportunity.Product2Id,opportunity.ListPrice);  
                        //assign products to their related opportunities
                        productOpportunities.put(opportunity.Product2Id, opportunity.OpportunityId);  
                    }
                List <ContractLineItem> contractLineItemsToBeInserted = new List<ContractLineItem>();

                //get pricebook entries in order to add them to contract line items
                List<PricebookEntry> priceBookEntries=[SELECT UnitPrice, Product2.Id, PriceBook2.Id FROM PricebookEntry Where Pricebook2Id IN :contractsToBeInsertedPriceBookIds AND Product2Id=:productPrices.keySet()];
                    
                System.debug('price book entries');
                System.debug(priceBookEntries);
                for(PricebookEntry entry:priceBookEntries){
                    ContractLineItem contractItem= new ContractLineItem();
                    ServiceContract serviceContract=contractsToBeInserted.get(productOpportunities.get(entry.Product2Id));
                    contractItem.ServiceContractId=serviceContract.Id;
                    contractItem.PricebookEntryId=entry.Id;
                    contractItem.UnitPrice=productPrices.get(entry.Product2Id);
                    contractItem.StartDate=serviceContract.StartDate;
                    contractItem.EndDate=serviceContract.EndDate;
                    contractItem.Quantity=1;
                    system.debug('contract to be inserted');
                    system.debug(contractItem);
                    contractLineItemsToBeInserted.add(contractItem);
                }

                if(contractLineItemsToBeInserted.size()>0){
                    insert contractLineItemsToBeInserted;
                }
            }
            
        }catch(Exception ex){
            throw ex;
        }
    }
}