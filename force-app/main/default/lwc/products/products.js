import { LightningElement, api, wire, track } from 'lwc';
import getProductList from '@salesforce/apex/LC01_PriceBookEntries_Controller.getProductList';
import updateContractPriceBookByAccountType from '@salesforce/apex/LC01_ServiceContract_Controller.updateContractPriceBookByAccountType'
//import saveContractLineItems from '@salesforce/apex/ServiceContractHelper.saveContractLineItems';
import saveContractLineItems from '@salesforce/apex/LC01_ContractLineItem_Controller.saveContractLineItems';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Products extends LightningElement {
    @api totalProducts;
    @api recordId;
    @api priceBookId;
    @api recordInformation;
    connectedCallback() {
        
        updateContractPriceBookByAccountType({serviceContractId:this.recordId}).then(result=>{
            console.log(this.recordId);
            let data=JSON.parse(result);
            this.priceBookId=data.Pricebook2Id;
            this.recordInformation= data;
            console.log('retrieved data is');
            console.log(this.priceBookId);
            console.log(this.recordInformation);
            console.log(this.recordInformation.Pricebook2Id);
            getProductList({priceBookId:this.priceBookId, startDate:this.recordInformation.StartDate,endDate:this.recordInformation.EndDate}).then(res=>{
                this.totalProducts=JSON.parse(res);
            }).catch(err=>{
                console.log('error while fetching products list on load');
                console.log(err);
            })
        }).catch(error=>{
            console.log(this.recordId);
            console.log('error while fetching pricebookid');
            console.log(error);
        })
    }

    renderedCallback() {
        // console.log('rendered------------');
        // console.log(this.recordId);
    }
    selectedProducts=[];
    visibleProducts;
    filterOptions;
    headerSelected=false;
    @track preSelectedRows;
    @track columns=[
        {label:'Vehicle Name', fieldName:'Name',type:'text'},
        {label:'Type',fieldName:'Family', type:'text'},
        {label:'Color',fieldName:'Color__c',type:'text'},
        {label:'Year Model',fieldName:'Model_Year__c',type:'number'},
        {label:'Number of People',fieldName:'Number_of_People__c',type:'number'},

    ];
    // @wire(getProductList, {priceBookId:this.priceBookId})
    // wiredProducts({error,data}){
    //     if(data){
    //         this.totalProducts=JSON.parse(data);
    //     }
    //     if(error){
    //         console.log('error');
    //         console.log(error);
    //     }
    // }
    handleAllProductsSelected(event) {
        for (var i = 0; i < this.totalProducts.length; i++) {
            this.totalProducts[i].IsSelected = event.target.checked;
        }
        this.headerSelected=event.target.checked;
        for(var j=0;j<this.visibleProducts.length;j++){
                this.visibleProducts[j].IsSelected=event.target.checked;
        }
    }
    handleProductSelected(event) {
        // console.log('index of selected product');
        // console.log(event.target.value);
        // console.log('visible product index');
        // console.log(Math.abs(event.target.value-5));
        // if(Math.abs(event.target.value-5)>4){
        //     this.visibleProducts[event.target.value].IsSelected=event.target.checked;
        // }else{
        //     this.visibleProducts[Math.abs(event.target.value-5)].IsSelected=event.target.checked;
        // }
        //console.log(this.visibleProducts[5-Math.abs(event.target.value-5)]);
        this.visibleProducts[event.target.value].IsSelected=event.target.checked;
        this.totalProducts[event.target.name].IsSelected = event.target.checked;
        // console.log('visible product is selected');
        // console.log(this.visibleProducts[event.target.value].IsSelected);

        // console.log('total products selected');
        // console.log(this.totalProducts[event.target.name].IsSelected);
        // console.log('is selected is');
        // console.log(this.totalProducts[event.target.value].IsSelected);
      }
    displayProducts(event){
        let data= JSON.parse(JSON.stringify(event.detail));
        this.filterOptions={
            recordTypeId:data.recordTypeId,
            family:data.family,
            color:data.color,
            year:data.year
        };
        console.log('filter options');
        console.log(this.filterOptions);
        getProductList({priceBookId:this.priceBookId,startDate:this.recordInformation.StartDate,endDate:this.recordInformation.EndDate,recordTypeId:this.filterOptions.recordTypeId,family:this.filterOptions.family,color: this.filterOptions.color,year: this.filterOptions.year}).then(result=>{
                this.totalProducts=JSON.parse(result);
                console.log(this.totalProducts.length);
        }).catch(error=>{
            console.log('error');
            console.log(error);
        })

    }
    clearFilter(event){
        getProductList({priceBookId:this.priceBookId,startDate:this.recordInformation.StartDate,endDate:this.recordInformation.EndDate}).then(result=>{
            // console.log('result');
            // console.log(result);
            this.totalProducts=JSON.parse(result);
            }).catch(error=>{
                console.log('error');
                console.log(error);
            })
    }
    updateProductsHandler(event){
        // console.log('records are');
        // console.log(event.detail.records);
        this.visibleProducts=[...event.detail.records];
        this.visibleProducts=JSON.parse(JSON.stringify(this.visibleProducts));
        let index=0;
        for(let i=0;i<this.visibleProducts.length;i++){
            this.visibleProducts[i].VisibleProductIndex=i;
        }
        // console.log('first visible product');
        // console.log(this.visibleProducts[0]);

        // for(let i=0;i<this.totalProducts.length;i++){
        //     //console.log(i-5);
        //     if(i-5<0){
        //         // console.log(this.visibleProducts[i]);
        //     }
        //     // if(i-5<0){
        //     //     this.visibleProducts[i].IsSelected=this.totalProducts[i].IsSelected;
        //     // }else{
        //     //     this.visibleProducts[i-5].IsSelected=this.totalProducts[i].IsSelected;
        //     // }
        // }
        // console.log(this.visibleProducts);
    }
    handleChange(event){
        console.log(event.target.value);
        this.totalProducts[event.target.name].UnitPrice=event.target.value;

    }
    handleSaveProducts(){
        let validate=true;
        console.log('length for selectedproducts');
        console.log(this.selectedProducts.length);
        this.selectedProducts=[];
      for(var i=0;i<this.totalProducts.length;i++){
        //   console.log(this.totalProducts[i]);
        if(this.totalProducts[i].IsSelected){
            
                // console.log('index of selected products');
                // console.log(this.selectedProducts.indexOf(this.totalProducts[i]));
                if(this.selectedProducts.indexOf(this.totalProducts[i])<0){
                    this.totalProducts[i].Quantity=1;
                    this.totalProducts[i].ServiceContractId=this.recordId;
                    this.totalProducts[i].StartDate=this.recordInformation.StartDate;
                    this.totalProducts[i].EndDate=this.recordInformation.EndDate;
                    this.selectedProducts.push(this.totalProducts[i]);
                }
              


        }
      }
      if(this.recordInformation.Account_Type__c==="Consumer" && this.selectedProducts.length>1){
        const evt = new ShowToastEvent({
            message: 'Consumers can only rent one vehicle',
            variant: 'error',
        });
        validate=false;
        this.dispatchEvent( evt );
        this.selectedProducts=[];
      }
    //   console.log('selected products are');
    //   console.log(JSON.stringify(this.selectedProducts));
      for(var j=0;j<this.selectedProducts.length;j++){
        if(!this.selectedProducts[j].UnitPrice){
            const evt = new ShowToastEvent({
                message: 'Please enter Rent Price for all Selected Products',
                variant: 'error',
            });
            validate=false;
            this.dispatchEvent( evt );
        }
        if(this.selectedProducts[j].UnitPrice && Number(this.selectedProducts[j].UnitPrice)<this.selectedProducts[j].ListPrice){
            const evt = new ShowToastEvent({
                message: 'Rent Price Cannot be less than Unit Price',
                variant: 'error',
            });
            validate=false;
            this.dispatchEvent( evt );
          }
        }
        // console.log('validate is');
        // console.log(validate);
        
        if(validate){
            saveContractLineItems({itemsString:JSON.stringify(this.selectedProducts)}).then(res=>{
                //console.log('Check apex logs');
                const evt = new ShowToastEvent({
                    message: 'Products Added Successfully',
                    variant: 'success',
                });
                
                this.dispatchEvent( evt );
                //empty selected products after selection
                this.selectedProducts=[];
            }).catch(error=>{
                console.log('error occurred while saving contract line items');
                console.log(error);
            })
        }
      

    }

}