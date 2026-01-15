namespace TopEtanch.TopEtanch;


using Microsoft.Sales.Receivables;
using Microsoft.Sales.Customer;

report 50033 "Etat de recouvrement/secteur"
{
    ApplicationArea = All;
    Caption = 'Etat de recouvrement par secteur';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Recouvrementpersecteur.rdl';
    dataset

    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "Salesperson Code", "Customer Posting Group", "No.", "City";
            column(Getfilters; Getfilters) { }
            column("CustomerNo"; "No.") { }
            column(City; City) { }
            dataitem(CustLedgerEntry; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No.");
                DataItemTableView = SORTING("Customer No.") where(Open = CONST(true));
                /*   WHERE(
                       Open = CONST(true),
                       "Document Type" = filter(Invoice | "Credit Memo")
                   );*/

                column(Entry_No_; "Entry No.")
                { }
                column(Nom_Client; "Nom Client")
                { }
                column(INFOCLIENT; INFOCLIENT) { }
                column("DocumentNo"; "Document No.")
                { }
                column("PostingDate"; "Posting Date")
                { }

                column("DocumentType"; "Document Type")
                {

                }

                column("Amount"; "Amount")
                {

                }

                column("RemainingAmount"; "Remaining Amount")
                {

                }

                column("DueDate"; "Due Date")
                {

                }
                column(Commercial; Commercial)
                {

                }
                trigger OnAfterGetRecord()
                begin
                    if "Salesperson Code" <> '' then
                        Commercial := "Salesperson Code"
                    else
                        Commercial := UserId();
                    if Customer.Get("Customer No.") then begin
                        INFOCLIENT := Customer.Address + ' / ' + Customer."Phone No.";
                    end;

                end;


            }

            trigger OnAfterGetRecord()
            var
                CLE: Record "Cust. Ledger Entry";
            begin
                CLE.SetCurrentKey("Customer No.", "Applies-to ID", Open, Positive, "Due Date");
                CLE.SetRange("Customer No.", Customer."No.");
                CLE.SetRange(Open, true);

                if not CLE.FindFirst() then
                    CurrReport.Skip();
            end;
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
    var
        commercial: text;
        INFOCLIENT: Text;
}
