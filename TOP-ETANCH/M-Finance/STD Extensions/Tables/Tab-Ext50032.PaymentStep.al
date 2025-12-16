namespace Top.Top;

using Microsoft.Bank.Payment;

tableextension 50032 "Payment Step" extends "Payment Step"
{
    fields
    {
        field(50100; "Impayé Client"; Boolean)
        {
            Caption = 'Impayé Client';
            FieldClass = Normal;
        }

        field(50101; "Comptabiliser RS Fournisseur"; Option)
        {
            Caption = 'Comptabiliser RS Fournisseur';
            FieldClass = Normal;
            OptionMembers = Acune,Validation,Annulation;
        }

        field(50102; "Comptabiliser Diff. de change"; Boolean)
        {
            Caption = 'Comptabiliser Diff. de change';
            FieldClass = Normal;
        }
        field(50103; "Compta. commission bancaire"; Boolean)
        {
            Caption = 'Compta. commission bancaire';
            FieldClass = Normal;
        }

        field(50104; "Compta. interêt bancaire"; Boolean)
        {
            Caption = 'Compta. interêt bancaire';
            FieldClass = Normal;
        }

        field(50105; "Comptabiliser TVA RS Publique"; Option)
        {
            Caption = 'Comptabiliser TVA RS Publique';
            FieldClass = Normal;
            OptionMembers = Acune,Validation,Annulation;
        }
        field(50106; "Default Step"; Boolean)
        {
            Caption = 'Default Step';
        }
    }
}
