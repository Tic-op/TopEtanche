tableextension 50025 "Entry Summary Ext" extends "Entry Summary"
{
    Caption = 'Entry Summary ';
    // DataClassification = ToBeClassified;
    // TableType = Temporary;

    fields
    {
        field(50000; "Demandée dans l'emplacement"; decimal)
        {
            Caption = 'Demandée dans l''emplacement';
        }
        field(50001; "Qté Restante par emplacement"; decimal)
        {
            CAption = 'Qté Restante par emplacement';
        }
    }

}
