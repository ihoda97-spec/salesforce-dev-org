import { LightningElement, api } from 'lwc';

export default class Pagination extends LightningElement {
    totalRecords;
    recordSize=5;
    currentPage=1;
    totalPage=0;
    get records(){
        return this.visibleRecords;
    }
    @api 
    set records(data){
        if(data){
            // console.log('data in pagination');
            // console.log(data);
            this.totalRecords=data;
           
            this.totalPage=Math.ceil(data.length/this.recordSize);
            this.updateRecords();
        }
    }
    get disablePreviousButton(){
        return this.currentPage<=1;
    }
    get disableNextButton(){
        return this.currentPage>=this.totalPage;
    }
    previousHandler(){
        if(this.currentPage>1){
            this.currentPage=this.currentPage-1;
            this.updateRecords();
        }
    }

    nextHandler(){
        if(this.currentPage<this.totalPage){
            this.currentPage=this.currentPage+1;
            this.updateRecords();
        }
    }
    updateRecords(){
        const start=(this.currentPage-1)*this.recordSize;
        const end=this.recordSize*this.currentPage;
        this.visibleRecords=this.totalRecords.slice(start,end);
        this.dispatchEvent(new CustomEvent('update',{
            detail:{
                records:this.visibleRecords
            }
        }))
    }
}