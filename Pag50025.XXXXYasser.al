namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.Document;

page 50025 "XXXX Yasser"
{
    ApplicationArea = All;
    Caption = 'XXXX Yasser';
    PageType = List;
    SourceTable = "Purchase Line";
    //   UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ToolTip = 'Specifies the name of the vendor who delivered the items.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the type of document that you are about to create.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the document number.';
                }
            }


        }
    }
    actions
    {
        area(Processing)
        {
            action("DeleetteNull")
            {
                ApplicationArea = All;
                Image = Approve;

                trigger OnAction()
                var
                    PL: Record "Purchase Line";
                begin
                    PL.SetRange("Document No.", '');

                    PL.DeleteAll();
                end;
            }
        }
    }
}
