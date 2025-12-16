namespace Top.Top;

using Microsoft.Bank.Payment;

pageextension 50051 "Payment Step Card" extends "Payment Step Card"
{
    layout
    {
        addafter("Source Code")
        {
            field("Impayé Client"; rec."Impayé Client")
            {
                ApplicationArea = All;
                Caption = 'Impayé Client';
                Editable = true;
                ToolTip = 'Constater l''impayé client lors de la validation de l''étape';
            }

            field("Comptabiliser RS Fournisseur"; Rec."Comptabiliser RS Fournisseur")
            {
                ApplicationArea = All;
                Editable = true;
                ToolTip = 'Constater la comptabilisation RS Fournisseur';
            }
            field("Comptabiliser TVA RS Publique"; rec."Comptabiliser TVA RS Publique")
            {
                ApplicationArea = All;
                Editable = true;
                ToolTip = 'Comptabiliser TVA RS Publique';
            }

            field("Comptabiliser Diff. de change"; Rec."Comptabiliser Diff. de change")
            {
                ApplicationArea = All;
                Editable = true;
                ToolTip = 'Comptabiliser Diff. de change : lors du FIN DEV Echu';
            }

            field("Compta. commission bancaire"; Rec."Compta. commission bancaire")
            {
                ApplicationArea = All;
                Editable = true;

            }

            field("Compta. interêt bancaire"; Rec."Compta. interêt bancaire")
            {
                ApplicationArea = All;
                Editable = true;

            }
            field("Default Step"; rec."Default Step")
            {
                ApplicationArea = All;
            }
        }

    }
}
