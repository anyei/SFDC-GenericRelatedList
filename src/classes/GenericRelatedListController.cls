/*Created by: Angel Robles
 * Created date: 4/25/2016
 * Purpose: Controller for VisualForce component GenericRelatedList
 * 
 */
public class GenericRelatedListController {

    
    public string FieldNames {get;set;}
    public string ConditionCriteria {get;set;}
    public string ObjectTypeName  {get;set;} 
    
    public integer total_size {get;set;} 
    public map<string,string> FieldsToDisplay {get;set;}
    public list<string> FieldKeys {get;set;}
     //used to show user the total size of the list 

    public GenericRelatedListController(){
       FieldsToDisplay = new Map<string,string>();
        FieldKeys = new list<string>(); 
        total_size = 0;
        
    }
    
    public PageReference BindData(){
         try{
        	total_size = integer.valueof(database.query('select count() from ' + ObjectTypeName + ((ConditionCriteria != null && ConditionCriteria != '') ? ' where ' + ConditionCriteria : '')));
        }catch(Exception e){}
        
        system.debug(FieldNames);
        system.debug(ObjectTypeName);
        system.debug(ConditionCriteria);
        
             
        List<string> fieldsToFind = FieldNames.split(',');
        
        if(ObjectTypeName != null && ObjectTypeName != ''){
            Schema.SObjectType sType= Schema.getGlobalDescribe().get(ObjectTypeName);
            Schema.DescribesObjectResult result =stype.getDescribe();
            Map<string,Schema.SObjectField> allFields = result.fields.getMap();
            
            for(string f : fieldsToFind){
                if(allFields.containsKey(f)){
                    Schema.SObjectField fieldDefinition =allFields.get(f);
                    Schema.DescribeFieldResult fr =FieldDefinition.getDescribe();
                    
                    FieldsToDisplay.put(f,fr.getLabel());
                }
            }
            
            FieldKeys = new List<string>(FieldsToDisplay.keyset());
        }
        
        return null;
    }
    
    public List<SObject> getRecords() {
        List<SObject> records = null;
        BindData();
        if(FieldNames != null && FieldNames !='' && ObjectTypeName !=null && ObjectTypeName != '' ){
           records = database.query('select '+FieldNames+ ' from '+ObjectTypeName +  ((ConditionCriteria != null && ConditionCriteria != '') ? ' where ' + ConditionCriteria : '') );

        }
        return records;	
    }
    
}