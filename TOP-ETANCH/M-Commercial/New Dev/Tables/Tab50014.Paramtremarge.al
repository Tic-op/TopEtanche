table 50014 "Paramêtre marge"
{
    Caption = 'Paramêtre marge';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Type articles"; Code[20])
        {
            Caption = 'Type articles';
            TableRelation = "Item Category".Code where(Level = const("type"));
            ValidateTableRelation = false;
        }
        field(2; "Groupe prix client"; Code[20])
        {
            Caption = 'Groupe prix client';
            TableRelation = "Customer Price Group".Code;
        }
        field(3; Marge; Decimal)
        {
            Caption = 'Marge';
            DecimalPlaces = 0 : 3;
        }

    }
    keys
    {
        key(PK; "Type articles", "Groupe prix client")
        {
            Clustered = true;
        }
    }

}
