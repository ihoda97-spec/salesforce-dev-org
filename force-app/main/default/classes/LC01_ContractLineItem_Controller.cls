/*
@author Hoda Ibrahim
@date 28/10/2021
@description: save selected products in contract line items
*/ 
public with sharing class LC01_ContractLineItem_Controller {
    public LC01_ContractLineItem_Controller() {

    }
    @AuraEnabled
    public static void saveContractLineItems(string itemsString){
        try {
            List<ContractLineItem> contractItems = new List<ContractLineItem>();
            JSONParser parser = JSON.createParser(itemsString);
            system.debug('items are');
            system.debug(itemsString);
            while(parser.nextToken()!=null){
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            //parse list of selectedProducts string to ContractLineItem object
                            ContractLineItem item = (ContractLineItem)parser.readValueAs(ContractLineItem.class);
                            system.debug('Item: '+ item.Id);
                            system.debug('product id'+ item.Product2.Id);
                            if(item!=NULL){
                                contractItems.add(item);
                            }
                        }
                    }

                }
            }
            if(contractItems.size()>0){
                system.debug('items to be inserted');
                system.debug(contractItems.size());
                insert contractItems;
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}