namespace Top.Top;

using Microsoft.Sales.Document;
using TopEtanch.TopEtanch;

pageextension 50032 SalesOrderList extends "Sales Order List"
{

    //InsertAllowed= false ;
    layout
    {


        modify("Sell-to Customer No.")
        {
            StyleExpr = StylePreparation;
        }

        modify("Sell-to Customer Name")
        {
            StyleExpr = StylePreparation;
        }
        modify("Posting date")
        {
            StyleExpr = StylePreparation;
        }
        modify("No.")
        {
            StyleExpr = StylePreparation;
        }
        addafter(Status)
        {
            field(Shipped; Rec.Shipped)
            {
                ApplicationArea = all;
            }
            field(Vendeur; Rec."Salesperson Code")
            {
                ApplicationArea = all;
            }
            field("Bon de preparations"; Rec."Bon de preparations")
            {
                Caption = 'Bon de preparations';
                ApplicationArea = all;

                trigger OnDrillDown()
                var
                    ListBonPre: Page "Liste bon de préparation";
                    OrderPre: record "Ordre de preparation";
                begin
                    OrderPre.setrange("Order No", rec."No.");
                    //   OrderPre.SetRange(Statut, OrderPre.Statut::"Préparé");
                    ListBonPre.SetTableView(OrderPre);
                    ListBonPre.Run();
                end;
            }
            field("Bon de preparations préparés"; Rec."Bon de preparations préparés")
            {
                Caption = 'Bon de préparations préparés';
                ApplicationArea = all;

                trigger OnDrillDown()
                var
                    ListBonPre: Page "Liste bon de préparation";
                    OrderPre: record "Ordre de preparation";
                begin
                    OrderPre.setrange("Order No", rec."No.");
                    OrderPre.SetRange(Statut, OrderPre.Statut::"Préparé");
                    ListBonPre.SetTableView(OrderPre);
                    ListBonPre.Run();
                end;
            }

        }
    }
    trigger OnAfterGetRecord()
    begin
        if (rec.Status = rec.Status::Open) and (Rec."Bon de preparations préparés" = Rec."Bon de preparations")
        and (Rec."Bon de preparations" <> 0) then
            StylePreparation := 'Favorable'
        else
            StylePreparation := 'Standard';
    end;

    trigger OnOpenPage()
    begin

        Rec.SetRange(Shipped, false);
    end;

    var
        StylePreparation: Text;
}
