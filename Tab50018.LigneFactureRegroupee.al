table 50018 "Ligne DocVente Regroupée"
{
    Caption = 'Ligne DocVente Regroupée';
    DataClassification = CustomerContent;


    //!!! TEMPORAIRE : utilisée uniquement dans le report

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }

        field(2; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DecimalPlaces = 0 : 5;
        }

        field(3; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
        }
        field(4; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure';
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(8; Amount; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 0 : 5;
        }

        field(9; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
        }

        field(10; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            DecimalPlaces = 0 : 5;
        }

        field(11; "Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT';
            DecimalPlaces = 0 : 5;
        }

    }

    keys
    {

        // ajouter "VAT %" si tu veux éviter de fusionner plusieurs taux
        key(PK;
        "Item No.",
            "Unit Price",
            "Line Discount %",
            "Unit of Measure Code")
        {
            Clustered = true;
        }
    }
}
