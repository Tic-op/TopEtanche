
namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.Payables;
using Microsoft.Purchases.Vendor;

pageextension 50072 "Vendor Ledger Entries" extends "Vendor Ledger Entries"
{
    layout
    {
        addafter("Vendor No.")
        {
            field("Nom Fournisseur"; VendorNameTxt)
            {
                ApplicationArea = all;

            }
        }
    }
    var
        VendorNameTxt: Text[100];
        Vend: Record Vendor;

    trigger OnAfterGetRecord()
    begin
        Clear(VendorNameTxt);
        if Vend.Get(Rec."Vendor No.") then
            VendorNameTxt := Vend.Name;
    end;

}
