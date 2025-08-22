namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.Document;

pageextension 50018 BlanketPurchaseOrderSubformExt extends "Blanket Purchase Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Planning de réception"; Rec."Expected Receipt Date") //IS 07082025
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
            field("Qty commandée"; Rec."Qty commandée")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Restant; Rec.Restant)
            {
                ApplicationArea = all;
                Editable = false;
            }


        }



    }
    actions //IS 07082025
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
                    if Rec."Document Type" <> Rec."Document Type"::"Blanket Order" then
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


            }
        }


    }
}
