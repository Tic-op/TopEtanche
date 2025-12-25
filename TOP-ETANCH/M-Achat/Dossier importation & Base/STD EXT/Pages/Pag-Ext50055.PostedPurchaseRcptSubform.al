namespace PHARMATEC.PHARMATEC;

using Microsoft.Purchases.History;

pageextension 50155 "Posted Purchase Rcpt. Subform" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Direct Unit Cost"; Rec."Direct Unit Cost")
            {
                ApplicationArea = All;
                Visible = true;
            }

        }
    }
}
