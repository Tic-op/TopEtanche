namespace Top.Top;

using Microsoft.Bank.Payment;

tableextension 50031 "Payment Status" extends "Payment Status"
{
    fields
    {
        field(50000; "Retenue a la source"; Boolean)
        {
            Caption = 'Retenue a la source';
            DataClassification = ToBeClassified;
        }
        field(50001; "Calcul des commissions"; Boolean)
        {
            Caption = 'Calcul des commissions';
            DataClassification = ToBeClassified;
        }
        field(50002; "Calcul des intérêts"; Boolean)
        {
            Caption = 'Calcul des intérêts';
            DataClassification = ToBeClassified;
        }
        field(50003; "Règl. Impayé"; Boolean)
        {
            Caption = 'Règl. Impayé';
            DataClassification = ToBeClassified;
        }
        field(50004; "Valid. Règl. Impayé partiel"; Boolean)
        {
            Caption = 'Valid. Règl. Impayé partiel';
            DataClassification = ToBeClassified;
        }
        field(50005; "Commission par bordereau"; Boolean)
        {
            Caption = 'Commission par bordereau';
            DataClassification = ToBeClassified;
        }
        field(50006; "Comm par Compte Ligne"; Boolean)
        {
            Caption = 'Comm par Compte Ligne';
            DataClassification = ToBeClassified;
        }
        field(50099; "Lettrage par N° seq"; Boolean)
        {
            Caption = 'Lettrage par N° seq';
            DataClassification = ToBeClassified;
        }
        field(60000; "Lettrage multiple"; Boolean)
        {
            Caption = 'Lettrage multiple';
            DataClassification = ToBeClassified;
        }
        field(60001; "Com Remises Chèques"; Boolean)
        {
            Caption = 'Com Remises Chèques';
            DataClassification = ToBeClassified;
        }
        field(60002; "Com Remises Effets"; Boolean)
        {
            Caption = 'Com Remises Effets';
            DataClassification = ToBeClassified;
        }
        field(60003; "Com Esc Effets"; Boolean)
        {
            Caption = 'Com Esc Effets';
            DataClassification = ToBeClassified;
        }
        field(60006; "Com Chèques Impayés"; Boolean)
        {
            Caption = 'Com Chèques Impayés';
            DataClassification = ToBeClassified;
        }
        field(60007; "Com Effets Impayés"; Boolean)
        {
            Caption = 'Com Effets Impayés';
            DataClassification = ToBeClassified;
        }
        field(60011; "Com Regl Effets"; Boolean)
        {
            Caption = 'Com Regl Effets';
            DataClassification = ToBeClassified;
        }
        field(60020; "Risque"; Option)
        {
            Caption = 'Risque';
            OptionMembers = " ",CPF,FACTORING,EPF,EEN,BQ;
            DataClassification = ToBeClassified;
        }

        field(60019; "Engagement financier"; Option)
        {
            Caption = 'Engagement financier';
            OptionMembers = " ","Effet à payer","Chèque à payer","Espèce ou virement à payer","Profoma Etranger","Titre Etranger","Virement Etranger","Lettre de crédit Etranger","Remise documentaire","Financement en devise","Découvert mobilisé";
            DataClassification = ToBeClassified;
        }
    }
}
