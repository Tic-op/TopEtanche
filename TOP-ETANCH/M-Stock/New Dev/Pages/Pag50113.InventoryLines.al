namespace TOPETANCH.TOPETANCH;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Counting.Journal;

page 50113 "Inventory Lines"
{
    ApplicationArea = All;
    Caption = 'Lignes';
    PageType = ListPart;
    SourceTable = "Inventroy Line";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Inventory No."; Rec."Inventory No.")
                {
                    ToolTip = 'Specifies the value of the N° inventaire field.', Comment = '%';

                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the N° article field.', Comment = '%';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Désignation field.', Comment = '%';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Code magasin field.', Comment = '%';
                }
                field(Inventory; Rec.Inventory)
                {
                    ToolTip = 'Specifies the value of the Stock field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }
                field("Count Num"; Rec."Count Num")
                {
                    ToolTip = 'Specifies the value of the N° Comptage actuel field.', Comment = '%';
                    ApplicationArea = all;

                }
                field("count 1 (QTY)"; Rec."count 1 (QTY)")
                {
                    ToolTip = 'Specifies the value of the count 1 (QTY) field.', Comment = '%';
                    DecimalPlaces = 0 : 3;

                }
                field("Ecart 1"; Rec."Ecart 1")
                {
                    ToolTip = 'Specifies the value of the Ecart 1 field.', Comment = '%';
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 3;
                }
                field("count 2 (QTY)"; Rec."count 2 (QTY)")
                {
                    ToolTip = 'Specifies the value of the count 2 (QTY) field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }
                field("Ecart 2"; Rec."Ecart 2")
                {
                    ToolTip = 'Specifies the value of the Ecart 2 field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }
                field("count 3 (QTY)"; Rec."count 3 (QTY)")
                {
                    ToolTip = 'Specifies the value of the count 3 (QTY) field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }
                field("Ecart 3"; Rec."Ecart 3")
                {
                    ToolTip = 'Specifies the value of the Ecart 3 field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }
                field("count 4 (QTY)"; Rec."count 4 (QTY)")
                {
                    ToolTip = 'Specifies the value of the count 4 (QTY) field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }
                field("Ecart 4"; Rec."Ecart 4")
                {
                    ToolTip = 'Specifies the value of the Ecart 4 field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }
                field("count 5 (QTY)"; Rec."count 5 (QTY)")
                {
                    ToolTip = 'Specifies the value of the count 5 (QTY) field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }
                field("Ecart 5"; Rec."Ecart 5")
                {
                    ToolTip = 'Specifies the value of the Ecart 5 field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }

                field("Qty to validate"; Rec."Qty to validate")
                {
                    ToolTip = 'Specifies the value of the Qty to validate field.', Comment = '%';
                    DecimalPlaces = 0 : 3;

                }
                field("Qté proposée"; Rec."Qté proposée")
                {
                    ToolTip = 'Specifies the value of the Qté proposée field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }

                field("Valeur art. inventoriés"; Rec."Valeur art. inventoriés")
                {
                    ToolTip = 'Specifies the value of the Valeur art. inventoriés field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }
                field("Valeur art. à inventorier"; Rec."Valeur art. à inventorier")
                {
                    ToolTip = 'Specifies the value of the Valeur art. à inventorier field.', Comment = '%';
                    DecimalPlaces = 0 : 3;

                }
                field("Bin code"; Rec."Bin code") { }
                field("N° lot"; Rec."N° lot") { }



            }

        }

    }
    trigger OnAfterGetRecord()
    var
        INVH: record "Inventory header";
        item: Record Item;
    begin
        if rec."Inventory No." <> '' then begin

            if INVH.get(rec."Inventory No.") then begin
                rec."Count Num" := INVH."Count No.";
                rec.modify;
            end;
        end;



        if item.Get(Rec."Item No.") then begin
            Rec."Item Description" := item."Description";
        end;

        rec."Ecart 1" := rec.Inventory - rec."count 1 (QTY)";
        rec."Ecart 2" := rec.Inventory - rec."count 2 (QTY)";
        rec."Ecart 3" := rec.Inventory - rec."count 3 (QTY)";
        rec."Ecart 4" := rec.Inventory - rec."count 4 (QTY)";
        rec."Ecart 5" := rec.Inventory - rec."count 5 (QTY)";


    end;

}
