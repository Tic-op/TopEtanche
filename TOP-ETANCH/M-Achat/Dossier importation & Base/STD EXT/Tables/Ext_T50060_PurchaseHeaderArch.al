tableextension 50060 purchaseHeaderArchExt extends "Purchase Header Archive"
{
    fields
    {
        field(50001; "DI No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No DI';
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}