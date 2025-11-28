/* table 50015 "Temp Bulk Att line"
{
    Caption = 'Temp Bulk Att line';
    DataClassification = ToBeClassified;
   
    TableType = Temporary;

    fields
    {
        field(1; "Line No."; Integer) { AutoIncrement = true; }
        field(2;"Attribute ID";integer){
           TableRelation= "Item Attribute".ID;

        }
        field(3; "Attribute Name"; Text[250]) {
            TableRelation = "Item Attribute".Name; 
            ValidateTableRelation= false ;
            trigger OnValidate()
            var IA : record "Item Attribute" ;
            begin 
               IA.setrange(Name,"Attribute Name");
               "Attribute ID":= "Attribute ID";
               Modify();
            end;

        }
        field(4; "Attribute Value"; Text[250]) {
            TableRelation= "Item Attribute Value".Value where("Attribute Name"=field("Attribute Name"));
            ValidateTableRelation= false ;
        }
    }

    keys
    {
        key(PK; "Line No.") { Clustered = true; }
    }
} */

    

