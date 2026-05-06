namespace Top.Top;

using Microsoft.Purchases.Payables;
using Microsoft.Bank.Payment;

pageextension 50059 "Apply Vendor Entries" extends "Apply Vendor Entries"
{
    layout
    {


        addafter("Currency Code")
        {


            field("Document Externe"; Rec."External Document No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Purchase (LCY)"; Rec."Purchase (LCY)")
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Montant HT';
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        PL: Record "Payment Line";
    begin

        if Rec.FindSet() then
            repeat
                if Rec."Applies-to ID" <> '' then begin
                    PL.Reset();
                    PL.SetRange("Applies-to ID", Rec."Applies-to ID");

                    if PL.FindFirst() then begin
                        if PL."Due Date" <> PL.DateEch then begin
                            PL."Due Date" := PL.DateEch;
                            PL.Modify();
                        end;
                    end;
                end;
            until Rec.Next() = 0;

        exit(true);
    end;
}
