namespace Top.Top;

using Microsoft.Bank.Payment;

pageextension 50055 "Payment Slip Subform" extends "Payment Slip Subform"
{
    layout
    {

        addlast(Control1)
        {
            field("Facture Caisse"; Rec."Facture Caisse")
            {
                ApplicationArea = all;
                Editable = false;
            }

        }

        modify("Amount")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
        modify("Due Date")
        {
            trigger OnAfterValidate()
            begin
                if Rec."Due Date" < Today then
                    Message('La date d''échéance ne peut pas être antérieure à la date du jour.');
            end;
        }
        modify("Debit Amount")
        {
            Visible = false;
        }
        modify("credit Amount")
        {
            Visible = false;
        }
        modify("Document No.")
        {
            Visible = false;
        }

        addafter(Amount)
        {
            field("TVA RS Pub"; rec."TVA RS Pub")
            {
                ApplicationArea = All;
                Visible = boolVisibleRSP;
            }

            /*field("Montant base RS"; Rec."Montant base RS")
            {
                ApplicationArea = All;
                Visible = boolVisibleRS;
            }
            field("Code RS"; Rec."Code RS")
            {
                ApplicationArea = All;
                Visible = boolVisibleRS;
            }*/


        }
        addafter("Account No.")
        {
            field(Designation; rec.Designation)
            {
                ApplicationArea = All;
            }
            field("External Document No"; Rec."External Document No.")
            {
                ApplicationArea = All;
                Caption = 'Référence';
            }


        }


        addafter("Bank Account Name")
        {

            field("RS VAT Amount"; Rec."RS VAT Amount")
            {
                ApplicationArea = All;
            }
            field("Montant RS VAT Amount"; rec."Montant RS VAT Amount")
            {
                ApplicationArea = All;
            }
            field("Copied To No."; Rec."Copied To No.")
            {
                ApplicationArea = All;
            }

        }
        modify("External Document No.")
        {
            Caption = 'Référence';
        }
        modify("Drawee Reference")
        {
            Visible = false;
        }
        modify("Payment Address Code")
        {
            Visible = false;
        }
        modify("Bank Branch No.")
        {
            Visible = false;
        }
        modify(IBAN)
        {
            Visible = false;
        }
        modify("SWIFT Code")
        {
            Visible = false;
        }
        modify("Agency Code")
        {
            Visible = false;
        }
        modify("RIB Key")
        {
            Visible = false;
        }
        modify("RIB Checked")
        {
            Visible = false;
        }
        modify("Has Payment Export Error")
        {
            Visible = false;
        }
        modify("Direct Debit Mandate ID")
        {
            Visible = false;
        }
        modify(Control1)
        {
            Editable = BoolEdit;
            Enabled = BoolEdit;


        }
    }
    actions
    {
        addafter(Modify)
        {

            action("Modifier ligne")
            {
                ApplicationArea = all;
                Image = Change;
                RunObject = page 50054;
                RunPageLink = "Document No." = field("Document No."), "Line No." = field("Line No.");

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        boolVisibleRS := Rec."Account Type" = Rec."Account Type"::Vendor;
        boolVisibleRSP := (StrPos(rec."Payment Class", 'Client PUBLIQUE') > 1) AND (Rec."Account Type" = Rec."Account Type"::Customer) and (rec."Currency Code" = '');

    end;



    trigger OnAfterGetCurrRecord()
    var
        PH: Record 10865;
    begin
        PH.get(rec."no.");
        if PH."Status No." <> 0 then
            BoolEdit := false
        else
            BoolEdit := true;
        //Message('%1', rec."Status No.");
    end;


    var
        boolVisibleRS: Boolean;
        BoolEdit, boolVisibleRSP : Boolean;

}
