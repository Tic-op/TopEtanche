namespace Top.Top;

using Microsoft.Bank.Payment;
using Microsoft.Foundation.Company;
using Pharmatec_Ticop.Pharmatec_Ticop;
using Microsoft.Bank.BankAccount;
using BCSPAREPARTS.BCSPAREPARTS;

report 50022 "Impression Effet Fournisseur"
{
    ApplicationArea = All;
    Caption = 'Impression Effet Fournisseur';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Traite Fournisseur.rdl';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem(PaymentLine; "Payment Line")
        {
            column(Account_No_; "Account No.")
            {

            }
            column(Designation; Designation)
            {

            }
            column(Amount; Amount)
            {

            }
            column(Due_Date; "Due Date")
            {

            }
            column(Montant_base_RS; "Montant base RS")
            {

            }
            column(Montant_RS; "Montant RS")
            {

            }
            column(Code_RS; "Code RS")
            {

            }
            column(Drawee_Reference; "Drawee Reference")
            {

            }
            column(Bank_Account_No_; "Bank Account No.")
            {

            }
            column(Status_Name; "Status Name")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(company_bankName; company_bankName)
            {

            }
            column(Company_address; Company_address)
            {

            }
            column(company_Vat_Number; company_Vat_Number)
            {

            }
            column(Company_RIB; Company_RIB) { }
            column(BankAgency; BankAgency) { }
            column(BankAddress; BankAddress) { }
            column(Company_Name; Company_Name) { }
            column(textmontant; textmontant) { }
            column(RIB1; RIB1) { }
            column(RIB2; RIB2) { }
            column(RIB3; RIB3) { }
            column(RIB4; RIB4) { }


            trigger OnAfterGetRecord()
            var

                Companyinfo: record "Company Information";
                bank: record "Bank Account";
                cu: Codeunit "Montant Toute Lettres";



            begin
                textmontant := '';
                Companyinfo.get();
                company_Vat_Number := Companyinfo."VAT Registration No.";
                Company_Name := Companyinfo.Name;
                Company_address := Companyinfo.Address;
                Company_RIB := Companyinfo."Bank Account No.";
                company_bankName := Companyinfo."Bank Name";
                BankAgency := Companyinfo."Bank Branch No.";
                bank.get(Companyinfo."Default Bank Account No.");
                BankAddress := Bank.Address;
                BankNo := bank."Bank Account No.";

                RIB1 := BankNo.Substring(1, 2);
                RIB2 := BankNo.Substring(3, 3);
                RIB3 := BankNo.Substring(6, 13);
                RIB4 := BankNo.Substring(19, 2);
                cu."Montant en texte"(textmontant, Amount);
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
        company_Vat_Number: text;

        Company_Name: text;
        Company_address: text;
        Company_RIB: text;
        company_bankName: text;
        BankAddress: text;
        BankAgency: text;
        RIB1, RIB2, RIB3, RIB4 : text;
        textmontant: text;
        BankNo: Text;

}
