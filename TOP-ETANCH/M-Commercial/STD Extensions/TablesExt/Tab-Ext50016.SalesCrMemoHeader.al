namespace PHARMATEC.PHARMATEC;

using Microsoft.Sales.History;

tableextension 50018 "Sales Cr.Memo Header" extends "Sales Cr.Memo Header"
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
