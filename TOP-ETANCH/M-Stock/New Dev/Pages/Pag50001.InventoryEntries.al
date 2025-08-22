namespace TOPETANCH.TOPETANCH;
using Microsoft.Inventory.Item;

page 50001 InventoryEntries
{
    ApplicationArea = All;
    Caption = 'InventoryEntries';
    PageType = Card;
    SourceTable = "Inventory Entry";
    UsageCategory = Administration;


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("N° inventaire"; Rec."Inventory No.")
                {
                    ToolTip = 'Specifies the value of the N° inventaire field.', Comment = '%';
                    ApplicationArea = all;
                }

                field("N° comptage"; Rec."Count No.")
                {
                    ToolTip = 'Specifies the value of the N° comptage field.', Comment = '%';
                    ApplicationArea = all;
                    TableRelation = "Inventory header" where("Count No." = field("Count No."));
                }
                /*  field("N° sequence"; Rec."Entry No.")
                 {
                     ToolTip = 'Specifies the value of the N° séquence field.', Comment = '%';
                     ApplicationArea = all;
                 } */
                field("N° article"; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the N° article field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("CAB article"; Rec."Item Bar Code")
                {
                    ToolTip = 'Specifies the value of the CAB article field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(Quantité; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantité field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Scan Date"; Rec."Scan Date")
                {
                    ToolTip = 'Specifies the value of the Date lecture field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Vrac Quantité"; Rec."Vrac Quantity")
                {
                    ToolTip = 'Specifies the value of the Quantité Vrac field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;

                }

            }
        }

    }

}
