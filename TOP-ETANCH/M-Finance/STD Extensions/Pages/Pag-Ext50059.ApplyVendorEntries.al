namespace Top.Top;

using Microsoft.Purchases.Payables;

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


}
