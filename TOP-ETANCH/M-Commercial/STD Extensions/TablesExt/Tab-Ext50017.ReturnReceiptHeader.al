namespace TopEtanch.TopEtanch;


using Microsoft.Sales.History;

tableextension 50017 "Return Receipt Header" extends "Return Receipt Header"
{
    fields
    {
        field(50000; "Stamp Amount"; Decimal)
        {
            Caption = 'Montant Timbre';
            DataClassification = ToBeClassified;
        }
    }
}
