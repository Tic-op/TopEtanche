namespace Top.Top;

using Microsoft.Bank.Payment;
using Microsoft.Foundation.Company;
using Microsoft.Purchases.Vendor;

report 50027 "Retenue Fournisseur"
{
    ApplicationArea = All;
    Caption = 'Retenue Fournisseur';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Retenue fournisseur.RDL';
    dataset
    {

        dataitem(PaymentLine; "Payment Line")
        {
            // DataItemLinkReference = PaymentHeader;
            //DataItemLink = "Document No." = field("no.");
            //DataItemTableView = where("Document No." = field("No."));

            column(Account_No_; "Account No.")

            { }

            column(CurrencyCode; "Currency Code")
            { }
            column(PostingDate; PostingDate)
            { }

            column(StatusName; StatusName)
            { }
            column(BankNO; PaymentHeader."Account No.") { }
            column(AmountHeader; AmountHeader) { }
            column(Document_No_; "Document No.") { }
            column(Due_Date; "Due Date") { }
            column(PaymentClassName; PaymentClassName) { }
            column(Designation; "Designation") { }
            column(Drawee_Reference; "Drawee Reference") { }
            column(Payment_Class; "Payment Class") { }
            column(Posting_Date; "Posting Date") { }
            column(Status_Name; "Status Name") { }
            column(Status_No_; "Status No.") { }
            column(Montant_base_RS; "Montant base RS") { }
            column(Montant_RS; "Montant RS") { }
            column(Code_RS; "Code RS") { }
            column(Nom; VendorNom) { }
            column(companyName; Companyinfo.Name) { }
            column(CompanyAdress; CompanyInfo.Address) { }
            column(CompanyActivité; CompanyInfo."Industrial Classification") { }
            column(CompanyFormlégale; CompanyInfo."Legal Form") { }
            column(CompanyRegistrationNum; CompanyInfo."Registration No.") { }
            column(CompanyVatRegNum; CompanyInfo."VAT Registration No.") { }
            column(VendorAddress; VendorAddress) { }
            column(VendorRegNum; VendorRegNum) { }
            column(VendorVatNum; VendorVatNum) { }






            trigger OnPreDataItem()
            begin

                CompanyInfo.get;
            end;



            trigger OnAfterGetRecord()
            var

                VendorVAR: record Vendor;
            begin
                PaymentHeader.Get("No.");
                // VendorVAR.SetRange("No.", PaymentLine."Account No.");

                //if VendorVAR.FindFirst() then
                VendorVAR.Get(PaymentLine."Account No.");
                VendorNom := VendorVAR.Name;
                VendorRegNum := VendorVAR."Registration Number";
                VendorVatNum := VendorVAR."VAT Registration No.";
                VendorAddress := VendorVAR.Address;
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
        VendorNom: Text[100];
        PaymentHeader: Record "Payment Header";
        PaymentClassName: Text[50];
        StatusName: Text[50];
        AmountHeader: Decimal;
        PostingDate: Date;
        CompanyInfo: Record "Company Information";
        VendorRegNum: text[50];
        VendorVatNum: text[50];
        VendorAddress: text[100];

}