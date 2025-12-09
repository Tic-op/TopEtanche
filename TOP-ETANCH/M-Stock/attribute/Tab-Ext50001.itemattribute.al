namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Item.Attribute;

/* tableextension 50001 "item attribute" extends "Item Attribute"
{
    fields
    {
        field(50000; "Type Attribut"; Code[25])
        {
            Caption = 'Catégorie Attribut';
            DataClassification = ToBeClassified;
            TableRelation = "Catégorie Attribut";
        }
        field(50001; Description; Text[100])
        {

        }

    }
} */
tableextension 50003 "item attribute Value" extends "Item Attribute Value"
{
    fields
    {
       /*  field(50000; "Type Attribut"; Code[25])
        {
            Caption = 'Catégorie Attribut';
            DataClassification = ToBeClassified;
            TableRelation = "Catégorie Attribut";
        } */
        field(50001;"Null Value";Boolean)
        { 
            
        }

    }
}
tableextension 50004 "item attribute Mapping" extends "Item Attribute Value Mapping"
{
    fields
    {
        field(50000;"Valeur attribut";Text[250])
        {
            Caption = 'Valeur Attribut';
            DataClassification = ToBeClassified;
           // TableRelation = "Item Attribute Value".Value where("Attribute ID" =field("Item Attribute ID"),ID = field("Item Attribute Value ID"));

        }
      /*   modify("Item Attribute Value ID"){
            trigger OnAfterValidate() 
            var 
             IAV : record "Item Attribute Value";
     begin
        if IAV.get("Item Attribute ID","Item Attribute Value ID") then 
        "Valeur attribut" := Iav.Value;
        Modify();
    end;
        } */
        

    }
    keys {

        key(keyvalue;"Valeur attribut"){}
    }
   trigger OnafterInsert() var 
    IAV : record "Item Attribute Value";
     begin
       IAV.get("Item Attribute ID","Item Attribute Value ID")  ;
        "Valeur attribut" := Iav.value;
       // Modify();
    end;
   

    
}

/*tableextension 50006 "item attribute Value Selection" extends "Item Attribute Value Selection"
{
    fields
    {
        field(50000; "Type Attribut"; Code[25])
        {
            Caption = 'Catégorie Attribut';
            DataClassification = ToBeClassified;
            TableRelation = "Catégorie Attribut";
        }
        field(50001; Description; text[100])
        {
        }



    }
} */

