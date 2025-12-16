namespace Top.Top;

using Microsoft.Bank.BankAccount;
using Microsoft.Foundation.AuditCodes;

tableextension 50034 "Bank Account" extends "Bank Account"
{
    fields
    {
        field(60001; "Com Remises Chèques"; Decimal)
        {
            Caption = 'Com Remises Chèques';
            DataClassification = ToBeClassified;
        }
        field(60002; "Com Remises Effets"; Decimal)
        {
            Caption = 'Com Remises Effets';
            DataClassification = ToBeClassified;
        }
        field(60003; "Com Esc Effets"; Decimal)
        {
            Caption = 'Com Esc Effets';
            DataClassification = ToBeClassified;
        }
        field(60006; "Com Chèques Impayés"; Decimal)
        {
            Caption = 'Com Chèques Impayés';
            DataClassification = ToBeClassified;
        }
        field(60007; "Com Effets Impayés"; Decimal)
        {
            Caption = 'Com Effets Impayés';
            DataClassification = ToBeClassified;
        }
        field(60008; "Com Chèques Certifiés"; Decimal)
        {
            Caption = 'Com Chèques Certifiés';
            DataClassification = ToBeClassified;
        }
        field(60011; "Com Regl Effets"; Decimal)
        {
            Caption = 'Com Regl Effets';
            DataClassification = ToBeClassified;
        }
        field(60020; "Journal"; Code[30])
        {
            Caption = 'Journal';
            DataClassification = ToBeClassified;
            TableRelation = "Source Code";
        }
        field(70008; "Plafond Escompte comm."; Decimal)
        {
            Caption = 'Plafond Escompte comm.';
            DataClassification = ToBeClassified;
        }
    }
}
