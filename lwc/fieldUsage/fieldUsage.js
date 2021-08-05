import { LightningElement, wire, track } from 'lwc';
import getAllFields from '@salesforce/apex/FieldUsage_LWC.getAllFields'
import getUsageNumbers from '@salesforce/apex/FieldUsage_LWC.getUsageNumbers'
const columns = [
    {
        label: "Label",
        fieldName: "label"
    },
    {
        label: "API Name",
        fieldName: "apiName"
    },
    {
        label: "Percentage",
        fieldName: "percentage"
    },
    {
        label: "Total",
        fieldName: "total"
    },
]
export default class FieldUsage extends LightningElement {
lObjectOptions = [
    {label:"Client", value:"Account"},
    {label:"Contact", value:"Contact"},
    {label:"Opportunity", value:"Opportunity"}
]
mLabelToAPI;
selectedObject;
selectedValues;
columns = columns;
data = [];
tableLoading = false;
showFields = false;

get hasResults(){
    return this.data.length > 0;
}

get tableLabel(){
    return this.selectedObject + ' Fields'
}

setObject(event){
    this.selectedObject = event.detail.value;
}

get objectSelected(){
    return this.selectedObject == undefined;
}

@wire(getAllFields, {objectAPIName: '$selectedObject'})
createPicklistValues(result){
    if(result.data){
        debugger;
        let mLabelToAPI = [];
        var data = result.data;
        for(var key in data){
            mLabelToAPI.push({label:key, value:data[key]}); //Here we are creating the array to show on UI.
        }
        this.mLabelToAPI =  mLabelToAPI.sort(function(a, b) {
            var labelA = a.label.toUpperCase(); // ignore upper and lowercase
            var labelB = b.label.toUpperCase(); // ignore upper and lowercase
            if (labelA < labelB) {
              return -1;
            }
            if (labelA > labelB) {
              return 1;
            }
          
            // names must be equal
            return 0;
          });
        this.showFields = true;
    } else if(result.error){
        console.log('error');
        console.log(result.error.message)
    }
}

updateSelectedList(event){
    this.selectedValues = event.detail.value;
    debugger;
}

usageNumbersCallout(){
    this.tableLoading = true;
 getUsageNumbers({lFieldAPINames : this.selectedValues, objectAPIName : this.selectedObject})
    .then(result => {
        this.data = result
        this.tableLoading = false;
    })
    .catch(error => {
        this.tableLoading = false;
    });
}
}