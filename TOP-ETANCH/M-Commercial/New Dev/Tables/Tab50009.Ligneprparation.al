table 50009 "Ligne préparation"
{
    Caption = 'Ligne préparation';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Source type."; Option)
        {
            Caption = 'Source type.'; 
            OptionMembers ="Commande","Transfert","Facture";
        }
        field(3; "Source No."; Code[20])
        {
            Caption = 'Source No.';
        }
        field(4; "Source line No."; Integer)
        {
            Caption = 'Source line No.';
        }
        field(5; "item No."; Code[20])
        {
            Caption = 'item No.';
            TableRelation = item ;
        }
        field(6; description; Text[100])
        {
            Caption = 'description';
        }
        field(7; Location; Code[10])
        {
            Caption = 'Location';
            
        }
        field(8; "Bin Code"; Code[10])
        {
            Caption = 'Bin Code';
        }
        field(9; Qty; decimal)
        {
            Caption = 'Qty';
        }
    }
    keys
    {
        key(PK; "Document No.", "Source type.", "Source No.", "Source line No.")
        {
            Clustered = true;
        }
    }
}
