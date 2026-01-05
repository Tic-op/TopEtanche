namespace Top.Top;

using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using Microsoft.Inventory.Item;

report 50017 TicketsRetour
{
    ApplicationArea = all;
    Caption = 'TicketsRetour';
    DefaultLayout = RDLC;
    RDLCLayout = 'TicketsPréparationRetour.rdl';
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = where("Document Type" = filter("Sales Document Type"::"Credit Memo" | "Sales Document Type"::"Return Order"));
            RequestFilterFields = "No.";
            column(No; Salesheader."No.")
            {
            }

            column(CustPhone; SalesHeader."Sell-to Phone No.") { }
            column(Magasin; salesheader."Location Code")
            {
            }

            column(Prparateur; Salesheader."Salesperson Code")
            {
            }
            column(documenttype; "document type")
            {
            }


            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = SalesHeader;

                column(Document_No_; "Document No.")
                {

                }
                column(Source_type_; "Document type") { }
                column(Source_No_; "Document No.") { }
                // column(Source_line_No_; "Source line No.") { }
                column(Destination; Salesheader."Sell-to Customer Name") { }
                //  column(CustPhone; CustPhone) { }
                column(Bin_Code; "Bin Code") { }
                column(item_No_; "No.") { }
                column(description; description) { }
                column(Qty; "Sales Line"."Quantity (Base)") { }
                column(vendorItemNo; vendorItemNo) { }
                /*  column(DD; Ordredepreparation."Date début préparation") { }
                 column(DF; Ordredepreparation."Date fin préparation") { } */
                Column(NumTicket; NumTicket) { }
                Column(TotalTicket; "Sales Line".count) { }

                trigger OnAfterGetRecord()
                var
                    SalesL: record "Sales Line";

                    Customer: Record Customer;
                    itemrec: record Item;
                begin


                    NumTicket += 1;


                    //  Destination := /*Demandeur + '  ' +*/ "Nom demandeur";



                    vendorItemNo := '';
                    if itemrec.get("No.") then begin

                        if itemrec."Vendor Item No." <> '' then vendorItemNo := itemrec."Vendor Item No."
                    end;
                end;
            }



        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(imprimer_destination; imprimer_destination)
                    {
                        Caption = 'Imprimer détails demandeur';
                        ApplicationArea = all;
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    trigger OnInitReport()
    begin
        imprimer_destination := true;
        NumTicket := 0;
    end;

    var
        CustName: text;
        imprimer_destination: Boolean;
        CustPhone: text;
        NumTicket: Integer;
        Destination: text;
        vendorItemNo: text;
}
