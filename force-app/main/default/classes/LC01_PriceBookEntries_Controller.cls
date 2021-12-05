/*
@author Hoda Ibrahim
@date 28/10/2021
@description: Get Vehicles (Price Book Entries) that are active for the current service contract
                Wrapper Class is used for adding contract line items after selecting the necessary products
*/  
public with sharing class LC01_PriceBookEntries_Controller {
    public LC01_PriceBookEntries_Controller() {

    }
    @AuraEnabled(cacheable=true)
    public static String getProductList(Id priceBookId, Date startDate, Date endDate, Id recordTypeId,String family, String color, String year){
        try {
        
            //return active products
            //Id recordTypeId=Id.valueOf(recordTypeIdString);
            system.debug('record type id in apex class is');
            System.debug(recordTypeId);
            string query= 'SELECT Product2.Id, Product2.Name, Product2.Family, Product2.Color__c, Product2.Model_Year__c, Product2.Number_of_People__c, UnitPrice FROM PriceBookEntry WHERE Product2.IsActive=true AND Product2.Family!=NULL AND PRICEBOOK2.Id=:priceBookId';
            //filtering fields
            if(recordTypeId!=NULL){
                system.debug(recordTypeId);
                recordTypeId=Id.valueOf(recordTypeId);
                query+=' AND Product2.RecordType.Id=:recordTypeId';
                system.debug(query);
            }
            // system.debug(query);
            if(family!=NULL && String.isNotBlank(family)){
                query+=' AND Product2.Family=:family';
            }
            if(color!=NULL && String.isNotBlank(color)){
                query+=' AND Product2.Color__c=:color';
            }
            if(year!=NULL && String.isNotBlank(year)){
                query+=' AND Product2.Model_Year__c=:year';
            }
            
            query+=' ORDER BY Product2.Model_Year__c DESC';
            system.debug(query);
            // this list is sent to lwc.
            List<LC02_PriceBookEntries_Wrapper> priceBookEntriesWrapList= new List<LC02_PriceBookEntries_Wrapper>();
            //get vehicles that are active during the time of current contract, to filter them out of the productWrapList
            List<ContractLineItem> activeContractLineItems=[SELECT Product2Id, Product2.Name 
                                                            FROM ContractLineItem 
                                                            WHERE StartDate=:startDate OR EndDate=:endDate];
            system.debug('active contract line items are');
            system.debug(activeContractLineItems);
            List<Id> productIds= new List<Id>();
            for(ContractLineItem contract:activeContractLineItems){
                
                productIds.add(contract.Product2Id);
            }

            //to assign index to the list sent to lwc
            Integer rowIndex=0;

            List<PricebookEntry> products=Database.query(query);
            if(products.size()>0){
                for(PricebookEntry product: products){
                    
                    if(!productIds.contains(product.Product2.Id)){
                        priceBookEntriesWrapList.add(new LC02_PriceBookEntries_Wrapper(product.Id,product.Product2.Id,product.Product2.Name,product.Product2.Family,product.Product2.Color__c,product.Product2.Model_Year__c,product.Product2.Number_of_People__c+'',product.UnitPrice,rowIndex));
                        rowIndex++;
                    }
            
                }
            }
            return JSON.serialize(priceBookEntriesWrapList);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
     
        }
    }
    public class LC02_PriceBookEntries_Wrapper{
        public String Product2Id;

        public String Name;
        public String Family;
        public String Color;
        public String YearModel;
        public String NumberOfPeople;
        public Decimal UnitPrice;
        public Decimal ListPrice;
        public Integer Index;
        public Integer VisibleProductIndex;
        public Boolean IsSelected;
        public Integer Quantity;
        public String ServiceContractId;
        public String PricebookEntryId;
        public Date StartDate;
        public Date EndDate;
        public LC02_PriceBookEntries_Wrapper(String Id,String Product2Id, String Name, String Family, String Color, String YearModel, String NumberOfPeople, Decimal UnitPrice,Integer Index){
            this.PricebookEntryId=Id;
            this.Product2Id=Product2Id;
            this.Name=Name;
            this.Family=Family;
            this.Color=Color;
            this.YearModel=YearModel;
            this.NumberOfPeople=NumberOfPeople;
            this.IsSelected=false;
            this.Index=Index;
            this.ListPrice=UnitPrice;
            //this.ActualRentPrice=0;

        }

    }
}