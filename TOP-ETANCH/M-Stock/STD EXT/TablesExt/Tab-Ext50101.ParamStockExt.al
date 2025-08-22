namespace TOPETANCH.TOPETANCH;

using Microsoft.Inventory.Setup;
using Microsoft.Foundation.NoSeries;

tableextension 50101 ParamStockExt extends "Inventory Setup"
{
    fields
    {
        field(50000; "Inventory No."; Code[25])
        {
            Caption = 'Inventaire No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }

    }
}
