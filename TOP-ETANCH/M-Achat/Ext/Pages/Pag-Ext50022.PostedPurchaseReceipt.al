namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.History;
using Microsoft.Inventory.Transfer;
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

                begin
                    Rec.CalcFields(Transfer);
                    if rec.transfer <> 0 then
                        error('Des transferts sont déja crées pour cette récéption ');
                    PurchRcLine.SetCurrentKey("Item Category Code");

                    itemCategory.SetCurrentKey("Default Depot");
                    if itemCategory.findfirst() then
                        repeat
                            PurchRcLine.setrange("Document No.", rec."No.");
                            PurchRcLine.SetRange("Item Category Code", itemCategory.code);
                            if PurchRcLine.findfirst() then
                                repeat

                                    insertTransferLine(Rec."No.", itemCategory."Default Depot", PurchRcLine);


                                until PurchRcLine.Next() = 0;

                        until itemCategory.next = 0;







                end;
            }
        }
    }

    procedure insertTransferLine(ReceiptHeaderNo: code[20]; Location: code[10]; PurchRcLine: record "Purch. Rcpt. Line")

    var
        TransferH: record "Transfer Header";
        TransferL: record "Transfer Line";

    begin

        TransferH.setrange("Num récéption", ReceiptHeaderNo);
        TransferH.setrange("Transfer-from Code", PurchRcLine."Location Code");
        TransferH.setrange("Transfer-to Code", Location);
        if not TransferH.findfirst then begin


            TransferH.reset();
            TransferH.init();
            TransferH.validate("Transfer-from Code", PurchRcLine."Location Code");
            TransferH.Validate("Transfer-To Code", Location);
            TransferH."Direct Transfer" := true;
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
