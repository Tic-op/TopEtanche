namespace Pharmatec_Ticop.Pharmatec_Ticop;

using Microsoft.Sales.History;
using Microsoft.Bank.Payment;

tableextension 50133 SalesInvoiceHeader extends "Sales Invoice Header"
{
    fields
    {
        field(50000; "Stamp Amount"; Decimal)
        {
            Caption = 'Montant Timbre';
            DataClassification = ToBeClassified;
        }
        field(50111; "Mode de livraison"; Option)
        {
            OptionMembers = "comptoir","Top Etanchéité","Transporteur Externe";

        }

    }
}
