namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.History;
using Microsoft.Inventory.Transfer;
using CPAIBC.CPAIBC;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;

pageextension 50022 "Posted Purchase Receipt" extends "Posted Purchase Receipt"
{
    layout
    {
        addlast(General)
        {
            group(transfer)
            {
                Enabled = true;
                field(Transfers; Rec.Transfer)
                {
                    ApplicationArea = all;
                    Enabled = true;
                    trigger ondrilldown()
                    var
                        TransferH: record "Transfer Header";
                        transferPage: page "Transfer Orders";
                    begin
                        TransferH.setrange("Num récéption", rec."No.");
                        transferPage.SetTableView(TransferH);
                        transferPage.RunModal();


                    end;
                }
            }

        }


    }
    actions
    {

        addafter("&Receipt")
        {

            action("Transférer les articles")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                Image = Allocate;




                trigger OnAction()
                var
                    itemCategory: Record "Item Category";
                    location: record Location;
                    PurchRcLine: Record "Purch. Rcpt. Line";
                    TransferH: record "Transfer Header";
                    item: Record item;

                begin
                    Rec.CalcFields(Transfer);
                    if rec.transfer <> 0 then
                        error('Des transferts sont déja crées pour cette récéption ');
                    PurchRcLine.SetCurrentKey("Item Category Code");

                    itemCategory.SetCurrentKey("Default Depot");
                    if itemCategory.findfirst() then
                        repeat
                            PurchRcLine.setrange(Type, PurchRcLine.Type::Item);
                            PurchRcLine.setrange("Document No.", rec."No.");
                            PurchRcLine.SetRange("Item Category Code", itemCategory.code);
                            if PurchRcLine.findfirst() then
                                repeat

                                begin
                                    item.Get(PurchRcLine."No.");
                                    if item."Default depot" <> '' then
                                        insertTransferLine(Rec."No.", item."Default depot", PurchRcLine)
                                    else begin
                                        if itemCategory."Default Depot" <> '' then
                                            insertTransferLine(Rec."No.", itemCategory."Default Depot", PurchRcLine)
                                        else
                                            error('Dépot par défaut manquant au niveau de l''article');
                                    end;

                                end;



                                until PurchRcLine.Next() = 0;

                        until itemCategory.next = 0;







                end;
            }
            action("Gérer les prix de vente")
            {
                Image = PriceWorksheet;
                ApplicationArea = all;
                trigger OnAction()
                var
                    RcptLine: Record "Purch. Rcpt. Line";
                    RcptHeader: Record "Purch. Rcpt. Header";
                begin
                    // RcptHeader.SetRange("DI No.", Rec."No.");
                    RcptHeader.setrange("No.", rec."No.");
                    RcptHeader.FindFirst();
                    RcptLine.SetRange("Document No.", RcptHeader."No.");
                    Page.RunModal(Page::"Purch Rcpt Pricing Worksheet", RcptLine);
                end;

            }

        }
    }

    procedure insertTransferLine(ReceiptHeaderNo: code[20]; Location: code[10]; PurchRcLine: record "Purch. Rcpt. Line")

    var
        TransferH: record "Transfer Header";
        TransferL: record "Transfer Line";
        Locationtransit: record Location;

    begin

        TransferH.setrange("Num récéption", ReceiptHeaderNo);
        TransferH.setrange("Transfer-from Code", PurchRcLine."Location Code");
        TransferH.setrange("Transfer-to Code", Location);
        if not TransferH.findfirst then begin


            TransferH.reset();
            TransferH.init();
            TransferH.validate("Transfer-from Code", PurchRcLine."Location Code");
            TransferH.Validate("Transfer-To Code", Location);
            //TransferH."Direct Transfer" := true;
            Locationtransit.setrange("Use As In-Transit", true);
            Locationtransit.FindFirst();
            TransferH.validate("In-Transit Code", Locationtransit.code);
            TransferH.validate("Num récéption", PurchRcLine."Document No.");
            TransferH.insert(true);


        end;
        TransferL.reset();
        TransferL.init();
        TransferL.Validate("Document No.", TransferH."No.");
        TransferL.validate("Item No.", PurchRcLine."No.");
        TransferL.Validate("Quantity (Base)", PurchRcLine."Quantity (Base)");
        TransferL.Validate("Line No.", PurchRcLine."Line No.");
        TransferL.insert(true);





    end;
}
