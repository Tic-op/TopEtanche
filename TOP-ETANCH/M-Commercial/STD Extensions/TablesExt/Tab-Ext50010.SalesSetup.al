namespace TopEtanch.TopEtanch;

using Microsoft.Sales.Setup;
using Microsoft.Foundation.NoSeries;

tableextension 50010 SalesSetup extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Bon de prepation No"; Code[25])
        {
            Caption = 'Bon de prepation No';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}
