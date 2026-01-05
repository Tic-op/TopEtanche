namespace TopEtanch.TopEtanch;

using Microsoft.Sales.History;
using Microsoft.Bank.Payment;

tableextension 50008 SaleInvoiceHeader extends "Sales Invoice Header"
{
    fields
    {
        field(50108; "Type de facturation"; Option)
        {
            OptionMembers = "","Contre remboursement","Fact. Mensuelle","Fact. Plafond","Commande Totale";
        }

        field(50004; "Règlement en cours"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Payment Line".Amount where("facture caisse" = field("No."), "Copied To No." = filter(''), "Status No." = filter(0)));
            Caption = 'Règlement caisse';

        }
    }
}
