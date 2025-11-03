table 50013 "Propriété matériaux"
{
    Caption = 'Propriété matériaux';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Code matériaux"; Code[50])
        {
            Caption = 'Code matériaux';
            TableRelation = "Fiche matériaux".Code ;
            ValidateTableRelation = true;
        }
        field(2; "Propriété"; text[250])
        {
            Caption = 'Attribut';
            TableRelation= "Item Attribute".Name;
            ValidateTableRelation= false ;
          
        }
        field(3; "Valeur par défaut"; Text[250])
        {
            Caption = 'Valeur par défaut';
            TableRelation = "Item Attribute Value".Value where ("Attribute Name"= field("Propriété"));
             ValidateTableRelation= false ;
        }
       
    }
    keys
    {
        key(PK; "Code matériaux","Propriété")
        {
            Clustered = true;
        }
    }
}
