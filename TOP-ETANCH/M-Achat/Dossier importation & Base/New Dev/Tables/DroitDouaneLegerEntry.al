table 50115 DroitDouaneLedgerEntry
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "DI No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Import Folder";
            Caption = 'No DI';
        }
        field(2; "NGP"; Code[25])
        {
            DataClassification = ToBeClassified;


        }
        field(3; "Origin"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
            Caption = 'Origine';
        }
        field(4; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Montant';

        }

    }

    keys
    {
        key(Key1; "DI No", NGP, Origin)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var


    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}