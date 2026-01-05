namespace Top.Top;

using Microsoft.Purchases.History;
using Microsoft.Purchases.Vendor;

pageextension 50062 "Posted Purchase Receipt Lin Ex" extends "Posted Purchase Receipt Lines"
{
    layout
    {
        addafter(Quantity)
        {

            field(NomFourn; NomFourn) { ApplicationArea = all; }
            field("Line Discount %"; Rec."Line Discount %") { ApplicationArea = all; }
            field("Posting Date"; Rec."Posting Date") { ApplicationArea = all; }

        }
    }
    trigger OnAfterGetRecord()
    var
        Vendor: Record Vendor;
    begin
        if Vendor.get(Rec."Buy-from Vendor No.") then
            NomFourn := vendor.Name;
    end;

    var
        NomFourn: Code[100];
}
