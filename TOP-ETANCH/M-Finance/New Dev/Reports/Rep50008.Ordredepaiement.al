namespace Top.Top;

using Microsoft.Bank.Payment;
using Microsoft.Purchases.Vendor;
using Microsoft.Foundation.Company;

report 50021 "Ordre de paiement "
{
    ApplicationArea = All;
    Caption = 'Ordre de paiement ';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Ordre de paiement.RDL';
    dataset
    {
        dataitem(PaymentLine; "Payment Line")
        {
            // DataItemLinkReference = PaymentHeader;
            //DataItemLink = "Document No." = field("no.");
            //DataItemTableView = where("Document No." = field("No."));

            column(Account_No_; "Account No.")

            {
            }
            column(CurrencyCode; "Currency Code")
            {
            }
            column(PostingDate; PostingDate)
            {
            }

            column(StatusName; StatusName)
            {
            }
            column(BankNO; PaymentHeader."Account No.") { }



            column(AmountHeader; AmountHeader)
            {
            }

            column(Account_Type; "Account Type")
            {
            }

            column(Agency_Code; "Agency Code")
            {
            }
            column(AmountLine; Amount) { }


            column(Document_No_; "Document No.") { }
            column(Due_Date; "Due Date") { }

            column(PaymentClassName; PaymentClassName)
            {
            }
            column(Designation; "Designation") { }
            column(Drawee_Reference; "Drawee Reference") { }

            column(Payment_Class; "Payment Class") { }
            column(Posting_Date; "Posting Date") { }
            column(Status_Name; "Status Name") { }
            column(Status_No_; "Status No.") { }
            column(Montant_base_RS; "Montant base RS") { }
            column(Montant_RS; "Montant RS") { }
            column(Code_RS; "Code RS") { }
            column(Nom; Nom) { }
            column(External_Document_No_; "External Document No.") { }
            column(picture; CompanyInfo.Picture) { }
            //     Column(HeaderJPG; CompanyInfo."Header JPG") { }
            //   column(FooterJPG; CompanyInfo."Footer JPG") { }

            trigger OnPreDataItem()
            begin
                CompanyInfo.get;
                CompanyInfo.CalcFields(Picture);//, "Header JPG", "Footer JPG");

            end;

            trigger OnAfterGetRecord()
            var

                VendorVAR: record "Vendor";
            begin
                PaymentHeader.Get("No.");
                // VendorVAR.SetRange("No.", PaymentLine."Account No.");

                //if VendorVAR.FindFirst() then
                VendorVAR.Get(PaymentLine."Account No.");
                Nom := VendorVAR.Name;
                PaymentHeader.calcfields("Payment Class Name");
                PaymentClassName := PaymentHeader."Payment Class Name";
                PaymentHeader.CalcFields(Amount);
                AmountHeader := PaymentHeader.Amount;
                PaymentHeader.calcfields("Status Name");
                StatusName := PaymentHeader."Status Name";
                PostingDate := PaymentHeader."Posting Date";


            end;


        }





    }


    var
        Nom: Text[100];
        PaymentHeader: Record "Payment Header";
        PaymentClassName: Text[50];
        StatusName: Text[50];
        AmountHeader: Decimal;
        PostingDate: Date;
        CompanyInfo: Record "Company Information";
}
