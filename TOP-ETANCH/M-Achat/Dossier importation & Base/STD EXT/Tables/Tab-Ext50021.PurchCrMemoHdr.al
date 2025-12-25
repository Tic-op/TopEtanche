namespace PHARMATEC.PHARMATEC;

using Microsoft.Purchases.History;

tableextension 50121 "Purch. Cr. Memo Hdr." extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(50001; "DI No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No DI';
        }
    }
}
