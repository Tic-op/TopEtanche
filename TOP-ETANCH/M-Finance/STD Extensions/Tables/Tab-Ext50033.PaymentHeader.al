namespace Top.Top;

using Microsoft.Bank.Payment;
using Microsoft.Bank.BankAccount;

tableextension 50033 "Payment Header" extends "Payment Header"
{
    fields
    {
        modify("Account No.")
        {
            trigger OnAfterValidate()
            var
                recBank: Record "Bank Account";
                PL: Record "Payment Line";

            begin
                if ("Source Code" = '') and ("Account Type" = "Account Type"::"Bank Account") and ("Account No." <> '') then begin
                    recBank.get("Account No.");
                    recBank.testfield(Journal);
                    "Source Code" := recBank.Journal;
                end;

                if ("Account Type" = "Account Type"::"Bank Account") and ("Account No." <> '') then begin
                    PL.SetFilter("No.", "No.");
                    if PL.FindFirst() then
                        repeat
                            PL."Banque Entête" := "Account No.";
                            PL.Modify(false);
                        until PL.next = 0;
                end;
            end;

        }



        field(50000; "Committees"; Decimal)
        {
            Caption = 'Commissions';
            DataClassification = ToBeClassified;


        }

        field(50001; "VAT Committees"; Decimal)
        {
            Caption = 'TVA sur Commissions';
            DataClassification = ToBeClassified;
        }

        field(50002; "Is commissioned"; Boolean)
        {
            Caption = 'Commissions comptabilisées';
            DataClassification = ToBeClassified;
        }

        field(50003; "Amount Interest (Actual)"; Decimal)
        {
            Caption = 'Montant Intérêt (Réél)';
            DataClassification = ToBeClassified;
        }

        field(50005; "Interest"; Boolean)
        {
            Caption = 'Intérêt comptabilisé';
            DataClassification = ToBeClassified;
        }
        
    }
}
