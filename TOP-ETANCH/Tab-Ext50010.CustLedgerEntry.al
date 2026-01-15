namespace Nouveaudossier.Nouveaudossier;

using Microsoft.Sales.Receivables;
using Microsoft.Sales.Customer;

tableextension 50100 "Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {


        field(50049; "Nom Client"; Text[100])
        {
            Caption = 'Nom Client';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name WHERE("No." = field("Customer No.")));
            Editable = false;

        }
    }
}
