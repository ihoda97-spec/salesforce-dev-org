import { LightningElement,api,wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import getProductRecordTypes from '@salesforce/apex/LC01_Products_Controller.getProductRecordTypes';
import { getPicklistValues, getObjectInfo} from 'lightning/uiObjectInfoApi';
import Family from '@salesforce/schema/Product2.Family';
import PRODUCT_OBJECT from '@salesforce/schema/Product2';

export default class FilterProducts extends LightningElement {
    @api vehicleTypeId;
    @api type;
    @api color;
    @api year;
    @api vehicle;
    @api retrievedProductTypes;
    @api relatedProductTypes;
    @wire(getObjectInfo, { objectApiName: PRODUCT_OBJECT })
    objectInfo;

    @wire(getProductRecordTypes) 
    retrieveProductRecordTypes({data,error}){
        if(data){
            let tempArray=[];
            for(let key in data){
                tempArray.push({label:data[key],value:key});
            }
            this.retrievedProductTypes=tempArray;
        }
        else if(error){
            console.log('error occurred while fetching product types');
            console.log(error);
        }
    }
    @wire(getPicklistValues, {
        recordTypeId: '$vehicleTypeId', 
        fieldApiName: Family
    }) familyPickListValues({data,error}){
        if(data){
            // console.log('data.values');
            // console.log(data.values);
            this.relatedProductTypes=data.values;
        }
        else if(error){
            console.log('error occurred while fetching types');
            console.log(error);
        }
    }
    // renderedCallback(){
    //     console.log('Inside Render, vehicleTypeId is');
    //     console.log(this.vehicleTypeId);
    // }
    get types(){
        return [
            {label:'Kia', value:'kia'},
            {label:'Mercedes',value:'mercedes'},
            {label:'Toyota',value:'toyota'}
        ];
    }
    get years(){
        return [
            {label:'2009',value:'2009'},
            {label:'2010',value:'2010'},
            {label:'2011',value:'2011'},
            {label:'2012',value:'2012'},
            {label:'2013',value:'2013'},
            {label:'2014',value:'2014'},
            {label:'2015',value:'2015'},
            {label:'2016',value:'2016'},
            {label:'2017',value:'2017'},
            {label:'2018',value:'2018'},
            {label:'2019',value:'2019'},
            {label:'2020',value:'2020'},
            {label:'2021',value:'2021'},
        ];
    }
    get colors(){
        return [
            {label:'Yellow',value:'yellow'},
            {label:'Navy',value:'navy'},
            {label:'Black',value:'black'},
            {label:'Blue',value:'blue'},
            {label:'Gray',value:'gray'},
            {label:'White',value:'white'},
            {label:'Red',value:'red'},
            {label:'Green',value:'green'},
            {label:'Pink',value:'pink'},
            {label:'Purple',value:'purple'},
        ];
    }
    handleVehicleTypeChange(event) {
        this.vehicleTypeId = event.detail.value;
        // console.log(event.detail);
        // console.log('selected vehicle type is');
        // console.log(this.vehicleTypeId);
    }
    handleTypeChange(event) {
        this.type = event.detail.value;
    }
    handleYearChange(event) {
        this.year = event.detail.value;
    }
    handleColorChange(event){
        this.color=event.detail.value;
    }
    handleFilterClick(){
        var vehicle={recordTypeId:this.vehicleTypeId,family:this.type,color:this.color,year:this.year};
        // console.log('in child component, vehicle is');
        // console.log(vehicle);
        const customEventCheck = new CustomEvent("valuecheck", {        
            detail:vehicle
        });
        this.dispatchEvent(customEventCheck); 
    }
    handleClearFilter(){
        var vehicle={}
        this.vehicleTypeId=undefined;
        this.type=undefined;
        this.color='';
        this.year='';
        //this.vehicle=undefined;
        const customEventCheck = new CustomEvent("clear", {        
            detail:vehicle
        });
        this.dispatchEvent(customEventCheck); 
    }
    handleCancelClick(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}