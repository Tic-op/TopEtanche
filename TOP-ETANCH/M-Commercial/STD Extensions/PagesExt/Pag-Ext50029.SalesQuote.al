namespace Top.Top;

using Microsoft.Sales.Document;
using Ticop_pharmatec.Ticop_pharmatec;
using TopEtanch.TopEtanch;

pageextension 50029 "Sales Quote" extends "Sales Quote"
{

    layout
    {
        addafter("Payment Terms Code")
        {
            field("Type de facturation"; rec."Type de facturation")
            {
                Visible = true;
                Caption = 'Type de facturation';
                ApplicationArea = all;
            }
        }
        modify("Work Description")
        {
            Visible = false;
        }
        modify("Shipping and Billing")
        {
            Visible = false;
        }
        modify("Prices Including VAT")
        {
            Visible = false;
        }
        modify(control47)
        {
            visible = false;
        }
        modify("Transaction Specification") { visible = false; }
        modify("Transaction Type") { visible = false; }
        modify("Payment Discount %") { visible = false; }
        modify("Pmt. Discount Date") { visible = false; }
        modify("Shortcut Dimension 1 Code") { Visible = false; }
        modify("Shortcut Dimension 2 Code") { visible = false; }
        modify("Foreign Trade") { visible = false; }
        modify("Sell-to Customer Templ. Code") { Visible = false; }
        modify("Your Reference") { Visible = false; }
        modify("Campaign No.") { Visible = false; }
        modify("Responsibility Center") { visible = false; }
        modify("Assigned User ID") { visible = false; }
        modify("Currency Code") { visible = false; }


    }

    actions //IS12092025
    {

        modify(MakeInvoice)
        {
            Enabled = rec."Type de facturation" = rec."Type de facturation"::"Contre remboursement";
            trigger OnAfterAction()
            var
                SE: Codeunit SalesEvents;
            begin
                SE.ArchiveDevis(rec."No.");
            end;

        }
        modify(MakeOrder)
        {     Caption= 'générer expédition vente';
            Enabled = rec."Type de facturation" <> rec."Type de facturation"::"Contre remboursement"; //AM à faire


            trigger OnAfterAction()
            var
                SE: Codeunit SalesEvents;
            begin
                SE.ArchiveDevis(rec."No.");
            end;
        }
       

        addlast(Processing)
        {

            action(CreateBlanketOrder)
            {
                ApplicationArea = All;
                Caption = 'Créer commande cadre vente ';
                Image = CreateWhseLoc;
                Promoted = true;
                PromotedCategory = Process;
                enabled = rec."Type de facturation" <> rec."Type de facturation"::"Contre remboursement";
                trigger OnAction()
                var
                    CVCMAKER: Codeunit SalesBlanketOrderFromQuote;
                    BlanketorderNo: code[20];
                    SH: record "Sales Header";
                    BlanketPage: page "Blanket Sales Order";
                begin
                    if not Confirm('Voulez-vous créer une commande vente cadre?') then
                        exit;
                    BlanketorderNo := CVCMAKER.StartCreationSalesBlanOrder(Rec."No.");
                    if SH.get("Sales Document Type"::"Blanket Order", BlanketorderNo) then
                        if Confirm('Voulez vous ouvrir la commande cadre crée ?', true) then begin
                            BlanketPage.SetRecord(SH);
                            BlanketPage.Run();

                        end;
                    //Get & Open the Sales B.O

                end;
            }
        }
    }
}
