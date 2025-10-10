namespace Top.Top;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Transfer;

report 50016 "BonPréparation"
{
    ;
    ApplicationArea = All;
    Caption = 'Tickets Préparation';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'TicketsPréparation.rdl';
    dataset
    {
        dataitem(Ordredepreparation; "Ordre de preparation")
        {
            RequestFilterFields = No;
            column(No; No)
            {
            }
            column(Statut; Statut)
            {
            }
            column(OrderNo; "Order No")
            {
            }
            column(Magasin; Magasin)
            {
            }
            column(Creationdate; "Creation date")
            {
            }
            column(Datedbutprparation; "Date début préparation")
            {
            }
            column(Datefinprparation; "Date fin préparation")
            {
            }
            column(Prparateur; "Préparateur")
            {
            }
            column(documenttype; "document type")
            {
            }



            dataitem("Ligne préparation"; "Ligne préparation")
            {
                DataItemLink = "Document No." = field(No);
                DataItemLinkReference = Ordredepreparation;

                column(Document_No_; "Document No.")
                {

                }
                column(Source_type_; "Source type.") { }
                column(Source_No_; "Source No.") { }
                column(Source_line_No_; "Source line No.") { }
                column(Destination; CustName) { }
                column(Bin_Code; "Bin Code") { }
                column(item_No_; "item No.") { }
                column(description; description) { }
                column(Qty; Qty) { }
                column(DD; Ordredepreparation."Date début préparation") { }
                column(DF; Ordredepreparation."Date fin préparation") { }

                trigger OnAfterGetRecord()
                var
                    SalesL: record "Sales Line";
                    TransferLine: record "Transfer Line";
                begin
                    SalesL.SetLoadFields("Document Type", "Document No.", "Line No.", Type, "Sell-to Customer No.", "Sell-to Customer Name");
                    SalesL.SetAutoCalcFields("Sell-to Customer Name");
                    If "Source type." = "Source type."::Commande then begin
                        SalesL.get("Sales Document Type"::Order, "Source No.", "Source line No.");

                        CustName := SalesL."Sell-to Customer Name";
                    end;

                    If "Source type." = "Source type."::Facture then begin


                        SalesL.get("Sales Document Type"::invoice, "Source No.", "Source line No.");
                        CustName := SalesL."Sell-to Customer Name";
                    end;
                    If "Source type." = "Source type."::Transfert then begin
                        TransferLine.get("Source No.", "Source line No.");
                        CustName := TransferLine."Transfer-to Code";
                    end;

                end;
            }




            /*   trigger OnAfterGetRecord()
              begin
                  Ordredepreparation.Printed += 1;
                  Modify(false);

              end; */



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

    trigger OnPostReport()
    begin
        Ordredepreparation.Printed += 1;
        Ordredepreparation.Modify(false);

    end;


    var
        CustName: text;
}
