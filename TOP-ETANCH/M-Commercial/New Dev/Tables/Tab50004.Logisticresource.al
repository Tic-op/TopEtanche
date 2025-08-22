table 50004 "Logistic resource"
{
    Caption = 'Logistic resource';
    DataClassification = ToBeClassified;
    LookupPageId = "Logistic resources list";
    DrillDownPageId = "Logistic resources list";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code préparateur';
        }

        field(2; "Nom"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Nom du préparateur';

        }

        field(3; "MotDePasse"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Mot de passe';
            NotBlank = true;
            ExtendedDatatype = Masked;

        }

        field(4; "Magasin"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Magasin';
            TableRelation = Location;


        }

        field(5; "Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Type';
            OptionMembers = "","Préparateur";
        }

        field(6; "blocked"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Bloqué';

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
