namespace Top.Top;

using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Item;

pageextension 50083 "item ledger entries" extends "Item Ledger Entries"
{

    layout
    {

        addafter("Item No.")
        {
            field(Famille; Rec.Famille)
            {
                ApplicationArea = all;

            }

            field(Fam; GetFamillyFromItem(Rec."Item No."))
            {

                ApplicationArea = all;
                Caption = 'Famille';
                Editable = false;
            }
            field("Sous-famille 1"; Rec."Sous-famille 1")
            {
                ApplicationArea = all;
            }
            field("Sous-famille 2"; Rec."Sous-famille 2")
            {
                ApplicationArea = all;
            }
            field("Désignation"; Rec."Designation")
            {
                ApplicationArea = all;
            }
            field("code vendeur"; rec."code vendeur")
            {
                ApplicationArea = all;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }


        }

        modify(Description)
        {
            Visible = false;
        }

        modify("Cost Amount (Actual)")
        {
            Visible = false;
        }
        modify("Cost Amount (Expected)")
        {
            Visible = false;
        }
        modify("Sales Amount (Actual)")
        {
            Visible = false;
        }
        modify("Sales Amount (Expected)")
        {
            Visible = false;
        }
        modify("Cost Amount (Non-Invtbl.)")
        {
            Visible = false;
        }
        modify("Cost Amount (Non-Invtbl.)(ACY)")
        {
            Visible = false;
        }
        addafter("Cost Amount (Actual)")
        {

            field("Operation Cost"; rec."Operation Cost")
            {
                ApplicationArea = all;
                trigger OnDrillDown()
                begin
                    ShowValueEntries;
                end;
            }
            field("Operation Amount"; rec."Sales Operation Amount")
            {
                ApplicationArea = all;
                trigger OnDrillDown()
                begin
                    ShowValueEntries;
                end;
            }
            field(calCostLine; calcCostLine())
            {
                ApplicationArea = all;
                Caption = 'Coût ligne';
                Editable = false;
                ToolTip = 'Coût ligne';
            }

            field("Profit Amount"; rec."Profit Amount")
            {
                ApplicationArea = all;
                trigger OnDrillDown()
                begin
                    ShowValueEntries;
                end;
            }
            field("Sale Profit %"; Rec."Profit %")
            {
                ApplicationArea = all;
            }
            field("Purchase Profit %"; Rec."Purchase Profit %")
            {
                ApplicationArea = all;
            }

        }
        addafter("Source No.")
        {

            field("Nom Origine"; rec."Nom Origine")
            {
                ApplicationArea = all;
            }
            field("Groupe Compta Client"; Rec."Groupe Compta Client")
            {
                ApplicationArea = all;
            }
        }
        addafter("Item No.")
        {
            field("reference fournisseur"; Rec."reference fournisseur")
            {
                ApplicationArea = all;
            }
        }




    }
    trigger OnOpenPage()
    begin
        //Rec.SetCurrentKey(key)
        rec.FILTERGROUP(2);
        rec.SetFilter(Quantity, '<>0');
        rec.FILTERGROUP(0);
        rec.SetCurrentKey("Item No.", "Posting Date");
    end;

    local procedure ShowValueEntries()
    var
        VE: Record "Value Entry";
    begin
        VE.SetCurrentKey("Item Ledger Entry No.", "Valuation Date", "Posting Date");
        VE.SetRange("Item Ledger Entry No.", Rec."Entry No.");
        Page.RunModal(5802, VE);
    end;

    local procedure GetFamillyFromItem(ItemNo: Code[20]): Text[100]
    var
        Item: Record Item;
    begin
        if Item.Get(ItemNo) then
            exit(Item."Item Category Code");
        exit('');
    end;

    local procedure calcCostLine(): Decimal
    begin
        rec.CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
        exit(rec."Cost Amount (Actual)" + rec."Cost Amount (Expected)");
    end;
}
