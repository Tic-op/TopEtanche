namespace TopEtanch.TopEtanch;

using Microsoft.Sales.Customer;

tableextension 50011 GroupClient extends "Customer Posting Group"
{
    fields
    {
        field(50000; Suspension; Boolean)
        {
            Caption = 'Suspension';
            DataClassification = ToBeClassified;
        }
    }
}
