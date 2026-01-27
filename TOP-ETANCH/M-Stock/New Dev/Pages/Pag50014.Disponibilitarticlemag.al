namespace TopEtanch.TopEtanch;
using Microsoft.Sales.Document;

page 50014 "Disponibilité article/mag"
{
    ApplicationArea = All;
    Caption = 'Disponibilité article/mag';
    PageType = Worksheet;
    SourceTable = "Item Distribution";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Item; Rec.Item)
                {
                    ToolTip = 'Specifies the value of the Article field.', Comment = '%';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Magasin field.', Comment = '%';
                }
                field("Qty to assign"; Rec."Qty to assign")
                {
                    ToolTip = 'Specifies the value of the Quantité à affecter field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }

                field(Qty; Rec.Qty)
                {
                    ToolTip = 'Specifies the value of the Disponibilité field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }

            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec.FindFirst() then
            repeat
                if Rec."Qty to assign" > 0 then
                    InsertLineInSales();
            until Rec.Next() = 0;
    end;


    procedure SetFilterItem(ItemNo: Code[20])
    begin
        Rec.SetRange(Item, ItemNo);
    end;

    procedure SetDoc2(Doc0: code[25]; Line0: Integer; total: Decimal)
    begin
        DocNo := Doc0;
        LineNo := Line0;
        "quantité totale" := total;
    end;

    procedure InsertLineInSales()
    var
        SL: Record "Sales Line";
        LastLineNo: Integer;
        ExistingLine: Record "Sales Line";
    begin

        ExistingLine.Reset();
        ExistingLine.SetRange("Document Type", ExistingLine."Document Type"::Order);
        ExistingLine.SetRange("Document No.", DocNo);
        ExistingLine.SetRange("No.", Rec.Item);

        if ExistingLine.FindFirst() then begin
            ExistingLine.Delete(true);
        end;


        SL.Reset();
        SL.SetRange("Document Type", SL."Document Type"::Order);
        SL.SetRange("Document No.", DocNo);

        if SL.FindLast() then
            LastLineNo := SL."Line No." + 1000
        else
            LastLineNo := 10000;


        SL.Init();
        SL."Document Type" := SL."Document Type"::Order;
        SL."Document No." := DocNo;
        SL."Line No." := LastLineNo;
        SL."No." := Rec.Item;
        SL."Location Code" := Rec."Location Code";
        SL."Bin Code" := Rec."Bin Code";
        SL.Validate("Quantity (Base)", Rec."Qty to assign");
        SL.Validate("Qty. to Ship (Base)", Rec."Qty to assign");
        SL.Insert(true);
    end;


    var
        SalesLine: Record "Sales Line";
        DocNo: Code[20];
        LineNo: Integer;
        "quantité totale": decimal;


}
