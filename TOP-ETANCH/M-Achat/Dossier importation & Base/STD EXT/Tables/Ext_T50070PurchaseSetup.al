tableextension 50070 purchsesetupExt extends "Purchases & Payables Setup"
{
    fields
    {
        field(50001; "Import folder No"; Code[20])
        {
            Caption = 'No Dossier importation';
            TableRelation = "No. Series";
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