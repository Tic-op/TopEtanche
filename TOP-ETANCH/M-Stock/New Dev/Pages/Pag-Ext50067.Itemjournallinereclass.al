namespace Top.Top;

using Microsoft.Inventory.Journal;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;

pageextension 50067 "Item journal line reclass" extends "Item Reclass. Journal"
{
    Layout
    {
        modify(Quantity)
        {
            StyleExpr = Color;
        }
        modify("Bin Code")
        {
            Visible = true;
        }
        modify("New Bin Code")
        {
            visible = true;
        }
        modify("Applies-to Entry")
        {
            Editable = false;

        }

    }




    actions
    {
        addlast(Processing)
        {
            action(ImportPurchaseQty)
            {
                Caption = 'Importer qtés restantes achetées';
                Image = CreateWhseLoc;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ImportReport: Report "Importer Qté Achat";

                begin
                    if not Confirm('Voulez-vous importer les quantités restantes vers la feuille de reclassement ?', false) then
                        exit;

                    ImportReport.InitJournal('TRANSFERT', 'RECL ACHAT');

                    ImportReport.RunModal();
                end;
            }
            action(UpdatePurchaseQty)
            {
                Caption = 'Mise à jour qtés restantes achetées';
                Image = CreateWhseLoc;
                ApplicationArea = All;
                visible = false;

                trigger OnAction()
                var
                    UpdateQtyReport: Report "Mise à jours qté restante";
                begin
                    if not Confirm('Voulez-vous mêttre à jours les quantités restantes dans la feuille de reclassement ?', false) then
                        exit;

                    UpdateQtyReport.InitJournal('TRANSFERT', 'RECL ACHAT');

                    UpdateQtyReport.RunModal();
                end;
            }


            action(UpdateNewLocationCode)
            {
                Caption = 'Affecter nouveau magasin';
                Image = Change;
                ApplicationArea = All;

                trigger OnAction()
                var
                    UpdateReclassReport: Report "Mise à jour magasin";
                    ItemJnlLine: Record "Item Journal Line";
                begin
                    if not Confirm('Voulez-vous affecter le nouveau magasin aux lignes visibles ?',
                        false) then
                        exit;

                    ItemJnlLine.Copy(Rec);
                    ItemJnlLine.SetRecFilter();

                    UpdateReclassReport.SetTableView(ItemJnlLine);

                    UpdateReclassReport.RunModal();
                end;
            }
        }


    }
    trigger OnAfterGetRecord()
    var
        ILE: Record "Item Ledger Entry";
    begin
        Color := 'Normal';
        If ILE.get(rec."Applies-to Entry") then
            if ILE."Remaining Quantity" <> Rec."Quantity (Base)" then
                Color := 'Unfavorable';
        ;
    end;


    var
        Color: Text;

}
