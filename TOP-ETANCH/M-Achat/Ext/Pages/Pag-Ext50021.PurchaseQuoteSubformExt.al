namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.Document;
using Microsoft.Sales.Document;

pageextension 50021 "Purchase Quote Subform Ext" extends "Purchase Quote Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Planning de réception"; Rec."Expected Receipt Date")
            {
                ApplicationArea = all;
                trigger OnLookup(var Text: Text): Boolean

                var
                    PurchasePlanningRec: Record PurchasePlanning;

                begin
                    //Show the vendor planning, must be replaced by onlookup in the subform quote
                    if rec."Document Type" <> rec."Document Type"::Quote then
                        exit;
                    PurchasePlanningRec.SetRange("Vendor No.", rec."Buy-from Vendor No.");
                    PurchasePlanningRec.SetFilter("Expected Date", '>%1', WorkDate());
                    PurchasePlanningRec.SetRange("Approved by Vendor", true);
                    PurchasePlanningRec.setrange("Real Date", 0D);

                    Page.RunModal(50024, PurchasePlanningRec);

                end;
            }
            field("Confirmé par fournisseur"; Rec."Confirmé par fournisseur")
            {
                ApplicationArea = all;


            }
            field("DOP sur Commande"; rec."DOP sur Commande")
            {
                Style = Favorable;
                BlankZero = true;
                ApplicationArea = all;

            }
            field("DOP sur Réception"; Rec."DOP sur Réception")
            {
                Style = Favorable;
                BlankZero = true;
                ApplicationArea = all;
            }



        }

    }
    actions
    {
        addafter("&Line")
        {
            action("Dupliquer ligne")
            {

                Caption = 'Dupliquer ligne';
                Image = CheckDuplicates;
                ApplicationArea = All;

                trigger OnAction()
                var
                    NewLine: Record "Purchase Line";
                    NewLineNo: Integer;
                begin
                    if Rec."Document Type" <> Rec."Document Type"::Quote then
                        exit;

                    NewLineNo := Rec."Line No." + 10;

                    NewLine.Init();
                    NewLine.TransferFields(Rec);
                    NewLine."Line No." := NewLineNo;
                    NewLine.Quantity := 0;
                    NewLine."Expected Receipt Date" := 0D;

                    NewLine.Insert(true);
                    NewLine.Validate(Quantity, 0);
                    NewLine.Modify()
                end;







                /*    trigger OnAction()
                   var
                       NewLine: Record "Purchase Line";
                       MaxLineNo: Integer;
                   begin
                       if Rec."Document Type" <> Rec."Document Type"::Quote then
                           exit;

                       NewLine.SetRange("Document Type", Rec."Document Type");
                       NewLine.SetRange("Document No.", Rec."Document No.");
                       if NewLine.FindLast() then
                           MaxLineNo := NewLine."Line No." + 10000
                       else
                           MaxLineNo := 10000;
                       NewLine.Init();
                       NewLine.TransferFields(Rec);
                       NewLine.Validate(Quantity, 0);
                       NewLine."Expected Receipt Date" := 0D;
                       NewLine."Line No." := MaxLineNo;
                       NewLine.Insert(true);
                   end;
                */

            }

        }

    }
}
