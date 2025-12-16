table 50016 "Retenue à la source"
{
    Caption = 'Retenue à la source';
    DataClassification = ToBeClassified;
      DrillDownPageId = "Retenue à la source Card";
    LookupPageId = "Retenue à la source Card";
    Permissions = tabledata "Retenue à la source" = Rimd;
    
   fields
    {
        field(1; "Code Retenue"; Code[20])
        {
            Caption = 'Code Retenue';
        }
        field(2; "Description"; Text[250])
        {
            Caption = 'Description';
        }
        field(3; "Taux"; Decimal)
        {
            Caption = 'Taux';
        }
        field(4; "Compte GL"; Code[20])
        {
            Caption = 'Compte GL';
            TableRelation = "G/L Account";
        }
    }
    keys
    {
        key(PK; "Code Retenue")
        {
            Clustered = true;
        }
    }
}
