namespace Top.Top;

using Microsoft.Bank.Payment;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Sales.Customer;
using Microsoft.Foundation.Company;

report 50026 "Retenue Client"
{
    ApplicationArea = All;
    Caption = 'Retenue Client';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Retenue Client.RDL';
    dataset
    {
        dataitem(PaymentLine; "Payment Line")
        {
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
            column(Amount; Abs(Amount)) { }
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
            column(Nom; CustNom) { }
            column(companyName; Companyinfo.Name) { }
            column(CompanyAdress; CompanyInfo.Address) { }
            column(CompanyActivité; CompanyInfo."Industrial Classification") { }
            column(CompanyFormlégale; CompanyInfo."Legal Form") { }
            column(CompanyRegistrationNum; CompanyInfo."Registration No.") { }
            column(CompanyVatRegNum; CompanyInfo."VAT Registration No.") { }
            column(CustAddress; CustAddress) { }
            column(CustRegNum; CustRegNum) { }
            column(CustVatNum; CustVatNum) { }
            column(taux; taux) { }
            column(RS_VAT_Amount; "RS VAT Amount") { }
            column(Montant_RS_VAT_Amount; "Montant RS VAT Amount") { }
            column(Applies_to_Doc__No_; "Applies-to Doc. No.") { }




            trigger OnPreDataItem()
            begin

                CompanyInfo.get;
            end;



            trigger OnAfterGetRecord()
            var

                CustVar: Record Customer;
                GLSetup: Record "General Ledger Setup";
            begin
                PaymentHeader.Get("No.");
                GLSetup.get();
                // VendorVAR.SetRange("No.", PaymentLine."Account No.");

                //if VendorVAR.FindFirst() then
                CustVar.Get(PaymentLine."Account No.");
                CustNom := CustVar.Name;
                CustRegNum := CustVar."Registration Number";
                CustVatNum := CustVar."VAT Registration No.";
                CustAddress := CustVar.Address;
                PaymentHeader.calcfields("Payment Class Name");
                PaymentClassName := PaymentHeader."Payment Class Name";
                PaymentHeader.CalcFields(Amount);
                AmountHeader := PaymentHeader.Amount;
                PaymentHeader.calcfields("Status Name");
                StatusName := PaymentHeader."Status Name";
                PostingDate := PaymentHeader."Posting Date";
                taux := GLSetup."TVA RS Publique";




            end;


        }

    }


    var
        CustNom: Text[100];
        PaymentHeader: Record "Payment Header";
        PaymentClassName: Text[50];
        StatusName: Text[50];
        AmountHeader: Decimal;
        PostingDate: Date;
        CompanyInfo: Record "Company Information";
        CustRegNum: text[50];
        CustVatNum: text[50];
        CustAddress: text[100];
        taux: Decimal;
        amount: Decimal;
}
