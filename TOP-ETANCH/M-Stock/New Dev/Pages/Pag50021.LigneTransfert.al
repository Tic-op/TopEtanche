namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Transfer;

page 50021 "Lignes transfert"
{
    ApplicationArea = All;
    Caption = 'Lignes Transfert';
    PageType = ListPart;
    SourceTable = "Transfer Line";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the number of the item that is transferred.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the item.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the quantity of the item that will be processed as the document stipulates.';
                }
                /*  field("Transfer-from Code"; Rec."Transfer-from Code")
                 {
                     ToolTip = 'Specifies the code of the location that items are transferred from.';
                 } */
                field("Transfer-from Bin Code"; Rec."Transfer-from Bin Code")
                {
                    ToolTip = 'Specifies the code for the bin that the items are transferred from.';
                }
                /* field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ToolTip = 'Specifies the code of the location that the items are transferred to.';
                }
                field("Transfer-To Bin Code"; Rec."Transfer-To Bin Code")
                {
                    ToolTip = 'Specifies the code for the bin that the items are transferred to.';
                } */
            }
        }
    }
}
