namespace SalesManagement.SalesManagement;

using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Inventory.Item;
using Microsoft.Finance.GeneralLedger.Account;

tableextension 50138 TableGLStampExtension extends "General Ledger Setup"
{
    fields
    {
        field(50137; "compte timbre fiscal"; Code[25])
        {
            Caption = 'Compte timbre fiscal';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }



        field(50138; "Montant timbre fiscal"; decimal)
        {
            Caption = 'Montant timbre fiscal';
            DataClassification = ToBeClassified;

        }

        field(50139; "Compte Fin. dev."; Code[25])
        {
            Caption = 'Compte Fin. dev.';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";

        }


        field(50140; "Compte Commission Bancaire"; Code[25])
        {
            Caption = 'Compte Commission Bancaire';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";

        }
        field(50141; "Compte TVA /Commission"; Code[25])
        {
            Caption = 'Compte TVA /Commission';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";

        }
        field(50142; "Compte Interrêt bancaire"; Code[25])
        {
            Caption = 'Compte Interrêt bancaire';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";

        }
        field(50133; "Frais timbre/Achat"; Code[25])
        {
            Caption = 'Frais timbre/Achat';
            DataClassification = ToBeClassified;
            TableRelation = "Item Charge";
        }
        field(50134; "Compte timbre/Achat"; Code[25])
        {
            Caption = 'Compte timbre/Achat';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50007; "TVA RS Publique"; Decimal)
        {
            Caption = 'Taux TVA RS Publique';
            DataClassification = ToBeClassified;
            //TableRelation = "G/L Account";

        }
        field(50008; "Compte TVA RS Publique"; Code[25])
        {
            Caption = 'Compte TVA RS Publique';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";

        }
        field(50014; "Gains écr. apurement"; Code[25])
        {
            Caption = 'Gains écr. apurement';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";

        }
        field(50015; "Pertes écr. apurement"; Code[25])
        {
            Caption = 'Pertes écr. apurement';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";

        }
    }
}


