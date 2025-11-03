table 50002 "Fiche matériaux"
{
    Caption = 'Fiche matériaux';
    DataClassification = ToBeClassified;
    LookupPageId = "Liste des matériaux" ;
    DrillDownPageId = "Liste des matériaux" ;
    
    
    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
           
        }
        field(2; Description; Text[500])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
