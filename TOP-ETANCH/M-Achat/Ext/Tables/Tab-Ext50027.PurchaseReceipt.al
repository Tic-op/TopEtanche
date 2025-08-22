namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.History;
using Microsoft.Inventory.Transfer;

tableextension 50027 PurchaseReceipt extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50200; Transfer; integer)
        {
            Caption = 'Transfer';

            FieldClass = FlowField;
            CalcFormula = count("Transfer Header" where("Num récéption" = field("No.")));
        }
    }
}
