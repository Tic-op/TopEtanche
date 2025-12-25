namespace Top.Top;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Transfer;
using Microsoft.Sales.Customer;

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
                column(Destination; Destination) { }
                column(CustPhone; CustPhone) { }
                column(Bin_Code; "Bin Code") { }
                column(item_No_; "item No.") { }
                column(description; description) { }
                column(Qty; Qty) { }
                column(DD; Ordredepreparation."Date début préparation") { }
                column(DF; Ordredepreparation."Date fin préparation") { }
                Column(NumTicket; NumTicket) { }
                Column(TotalTicket; "Ligne préparation".count) { }

                trigger OnAfterGetRecord()
                var
                    SalesL: record "Sales Line";
                    TransferLine: record "Transfer Line";
                    Customer: Record Customer;
                begin
                    Customer.SetLoadFields("No.", Name, "Phone No.", "Mobile Phone No.");
                    SalesL.SetLoadFields("Document Type", "Document No.", "Line No.", Type, "Sell-to Customer No.", "Sell-to Customer Name");
                    SalesL.SetAutoCalcFields("Sell-to Customer Name");
                    CustName := '';
                    CustPhone := '';
                    NumTicket += 1;
                    if imprimer_destination then begin
                        if ("Source type." = "Source type."::Commande) or ("Source type." = "Source type."::Facture) then begin
                            Customer.get(Demandeur);
                            CustPhone := Customer."Phone No.";
                        end;
                        Destination := Demandeur + '  ' + "Nom demandeur";

                    end;


                    /* 
                                            If "Source type." = "Source type."::Commande then begin
                                                SalesL.get("Sales Document Type"::Order, "Source No.", "Source line No.");

                                                Customer.get(SalesL."Sell-to Customer No.");
                                                CustName := SalesL."Sell-to Customer Name";
                                                CustPhone := Customer."Phone No.";
                                            end;

                                            If "Source type." = "Source type."::Facture then begin


                                                SalesL.get("Sales Document Type"::invoice, "Source No.", "Source line No.");

                                                Customer.get(SalesL."Sell-to Customer No.");
                                                CustName := SalesL."Sell-to Customer Name";
                                                CustPhone := Customer."Phone No.";

                                            end;
                                            If "Source type." = "Source type."::Transfert then begin
                                                TransferLine.get("Source No.", "Source line No.");
                                                CustName := TransferLine."Transfer-to Code";
                                                CustPhone := '';
                                            end; */

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

    trigger OnPostReport()
    begin
        Ordredepreparation.Printed += 1;
        Ordredepreparation.Modify(false);

    end;

    trigger OnInitReport()
    begin
        imprimer_destination := false;
        NumTicket := 0;

    end;


    var
        CustName: text;
        imprimer_destination: Boolean;
        CustPhone: text;
        NumTicket: Integer;
        Destination: text;
}
