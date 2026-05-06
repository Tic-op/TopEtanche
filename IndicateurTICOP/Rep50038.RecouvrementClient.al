namespace Top.Top;

using Microsoft.Sales.Receivables;
using Microsoft.Sales.Customer;

report 50038 "Recouvrement Client"
{
    ApplicationArea = All;
    Caption = 'Recouvrement Client';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Recouvrement_Client.RDL';
    dataset
    {
        dataitem(CustLedgerEntry; "Cust. Ledger Entry")
        {
            RequestFilterFields = "Customer No.", "Posting Date";//, "Customer Name";
            DataItemTableView = sorting("Posting Date") Order(descending) where("Document Type" = const("Document Type"::Invoice));


            Column(Entry_No_; "Entry No.")
            {

            }
            column(CustomerNo; "Customer No.")
            {
            }
            Column(Customer_Name; CustName)
            { }
            column(PostingDate; "Posting Date")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(Amount; Amount)
            {
            }
            column(OriginalAmtLCY; "Original Amt. (LCY)")
            {
            }
            column(RemainingAmount; "Remaining Amount")
            {
            }
            dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
            {
                DataItemLinkReference = CustLedgerEntry;
                DataItemLink = "Cust. Ledger Entry No." = field("Entry No.");
                //"Applied Cust. Ledger Entry No." = field("Entry No.");
                DataItemTableView = where("Entry Type" = const("Entry Type"::application));

                Column(Applied_Cust__Ledger_Entry_No_; "Cust. Ledger Entry No.")//"Applied Cust. Ledger Entry No.")
                {

                }
                column(DCLEAmount; Amount) { }
                Column(DCLEDocument_No_; "Detailed Cust. Ledg. Entry"."Document No.")
                { }

                trigger OnAfterGetRecord()
                var
                    CLE: Record "Cust. Ledger Entry";

                begin
                    /*     DCLEDocumentNo := '';

                        if CLE.get("Cust. Ledger Entry No.") then
                            DCLEDocumentNo := CLE."Document No."; */


                end;
            }

            trigger OnPreDataItem()
            var
                FilterTxt: Text;
                customer: record Customer;
            begin
                FilterTxt := GetFilter("Customer No.");

                if FilterTxt = '' then
                    Error('Veuillez choisir un Client');

                if StrPos(FilterTxt, '|') > 0 then
                    Error('Veuillez choisir un seul Client (pas une liste)');
                Customer.get(FilterTxt);
                CustName := Customer.Name;
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
        DCLEDocumentNo: Text;
        CustName: text;

}
