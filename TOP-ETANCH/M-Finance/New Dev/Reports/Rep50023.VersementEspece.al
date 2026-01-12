namespace Top.Top;

using Microsoft.Bank.Payment;
using Microsoft.Bank.BankAccount;
using Microsoft.Foundation.Company;
using Pharmatec_Ticop.Pharmatec_Ticop;

report 50023 "Versement Espece"
{
    ApplicationArea = All;
    Caption = 'Versement Espece';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Versement Espece.rdl';
    DefaultLayout = RDLC;
    dataset
    {

        dataitem(Paiementline; "Payment Line")
        {
            column(No_; "No.") { }


            Column(CurrencyCode; "Currency Code") { }
            Column(PaymentClass; "Payment Class") { }
            Column(StatusName; "Status Name") { }

            Column(Amount; Amount) { }
            Column(BankName; BankName) { }
            Column(societe; CompanyInfo.Name) { }
            Column(UserCreator; '') { }

            Column(PostDate; PostingDate) { }
            column(companyName; Companyinfo.Name) { }

            Column(compte; "Account No.") { }
            column(CompteBancaire; compteB) { }
            Column(Designation_PaymentLine; Designation) { }
            Column(Reftiree; "External Document No.") { }
            Column(Bank_Account_Name; "Bank Account Name") { }
            column(Bank_Account_Code; "Bank Account Code") { }
            column(Bank_Account_No_; "Bank Account No.") { }
            Column(AmountLine; abs("Amount")) { }
            Column(Echéance; "Due Date") { }

            column("Count"; Count) { }

            column(MontantH; MontantH) { }

            column(Vat_Reg_No; Vat_Reg_No) { }
            column(TextMontant; TextMontant) { }
            column(Titre; TitleText) { }
            column(BQ; BQ) { }
            column(RIB; RIB) { }
            column(affichage; affichage) { }
            column(picture; CompanyInfo.Picture) { }
            //     Column(HeaderJPG; CompanyInfo."Header JPG") { }
            //     column(FooterJPG; CompanyInfo."Footer JPG") { }


            trigger OnPreDataItem()
            begin
                CompanyInfo.get;
                CompanyInfo.CalcFields(Picture);//, "Header JPG", "Footer JPG");

                Montant := 0;
                Vat_Reg_No := '';
                TextMontant := '';

            end;

            trigger OnAfterGetRecord()

            var

                MontantLettre: Codeunit "Montant Toute Lettres";



            begin
                TextMontant := '';
                Montant := 0;


                //Message("No.");
                PaymentHeader.Get("No.");
                BQ := PaymentHeader."Account No.";
                RIB := PaymentHeader."Bank Account No.";
                BankAccount.get(PaymentHeader."Account No.");

                BankName := BankAccount.Name + '\n' + ' RIB : ' + BankAccount."Bank Account No.";


                PostingDate := PaymentHeader."Posting Date";
                Montant := Montant + Amount;
                PaymentHeader.CalcFields(Amount);
                MontantH := abs(PaymentHeader.Amount);

                MontantLettre."Montant en texte"(TextMontant, MontantH);

                TitleText := "Payment Class" + "Status Name";

                if TitleText.Contains('ESPECE') then begin
                    TitleText := 'Bordereau de Versement Espèce';
                    affichage := false;
                end;




            end;

        }

    }

    var
        NombrePièce: Integer;
        CompanyInfo: Record "Company Information";
        BankAccount: Record "Bank Account";// TODO DATA IN TABLE 
        PaymentHeader: Record "Payment Header";
        NBPIèce: integer;
        BankName: Text[100];
        PostingDate: Date;
        Montant: Decimal;
        MontantH: Decimal;
        compteB: Code[25];
        Vat_Reg_No: text;
        TextMontant: text[8000];
        TitleText: text;
        BQ: Text;
        RIB: Text;
        affichage: Boolean;
}
