namespace Top.Top;

using Microsoft.Sales.Receivables;

pageextension 50058 "Apply Customer Entries" extends "Apply Customer Entries"
{layout
    {


        addafter("Currency Code")
        {


            field("Document Externe"; Rec."External Document No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Sales (LCY)"; Rec."Sales (LCY)")
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Montant HT';
            }
        }
    }

}
