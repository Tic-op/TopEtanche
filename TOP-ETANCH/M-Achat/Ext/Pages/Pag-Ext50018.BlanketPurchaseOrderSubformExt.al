namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.Document;
using Top.Top;

pageextension 50018 BlanketPurchaseOrderSubformExt extends "Blanket Purchase Order Subform"
{
    layout
    {
        addafter("No.")
        {
            Field("Country region origin code"; Rec."Country region origin code")
            {
                ApplicationArea = all;
            }
            Field("Tariff No."; Rec."Tariff No.")
            {
                ApplicationArea = all;
            }
        }
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
            Field("Requested Receipt Date"; Rec."Requested Receipt Date")
            {
                ApplicationArea = all;
            }
            Field("Promised Receipt Date"; Rec."Promised Receipt Date")
            {
                ApplicationArea = all;
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
        addafter(Invoices)
        {
            Action(Recherche_Ticop)

            {
                ShortcutKey = 'Alt+W';
                ApplicationArea = all;
                Image = AddWatch;
                trigger OnAction()
                var
                    RS: Page "Usual search Purchase";
                    PurchaseHeader: record "Purchase Header";
                begin
                    PurchaseHeader.Get(Rec."Document Type", Rec."Document No.");
                    PurchaseHeader.TestField(Status, PurchaseHeader.Status::Open);
                    RS.initvarPurch(PurchaseHeader."Document Type", PurchaseHeader."No.");
                    //RS.Run();
                    rs.RunModal();

                    // Page.RunModal(50029);
                    CurrPage.Update();



                end;
            }
        }



    }
}
