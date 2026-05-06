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
                rec.DateEch := Rec."Due Date";
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
                /* trigger OnValidate()
                 var
                     PaymentLine: Record "Payment Line";
                     count: Integer;
                 begin
                     if Rec."External Document No." = '' then
                         exit;

                     PaymentLine.Reset();
                     PaymentLine.SetRange("External Document No.", Rec."External Document No.");

                     PaymentLine.SetFilter("Line No.", '<>%1', Rec."Line No.");

                     if PaymentLine.FindSet() then begin
                         repeat
                             count += 1;
                         until PaymentLine.Next() = 0;
                     end;

                     if count > 0 then
                         error('Attention, ce numéro de référence est déjà utilisé dans %1 autre(s) ligne(s) de paiement. %2', count);
                 end;*/
                trigger OnValidate()
                var
                    PaymentLine: Record "Payment Line";
                    count: Integer;
                    BordereauxList: Text;
                begin
                    if Rec."External Document No." = '' then
                        exit;

                    PaymentLine.Reset();
                    PaymentLine.SetRange("External Document No.", Rec."External Document No.");
                    //PaymentLine.SetFilter("Line No.", '<>%1', Rec."Line No.");


                    count := PaymentLine.Count();

                    if count > 0 then begin


                        if PaymentLine.FindSet() then
                            repeat
                                if BordereauxList = '' then
                                    BordereauxList := PaymentLine."No."
                                else
                                    if StrPos(BordereauxList, PaymentLine."No.") = 0 then
                                        BordereauxList += ', ' + PaymentLine."No.";
                            until PaymentLine.Next() = 0;

                        Error('Ce numéro de référence est déjà utilisé dans %1 ligne(s), bordereau(x) : %2', count, BordereauxList);
                    end;
                end;
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
                RunPageLink = "No." = field("No."), "Line No." = field("Line No.");

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

    trigger OnDeleteRecord(): Boolean// OD 
    begin
        if Rec."Copied To No." <> '' then
            Error('vous ne pouvez pas supprimer cette ligne');
        if rec."Created from No." <> '' then
            Error('vous ne pouvez pas supprimer cette ligne');
    end;


    var
        boolVisibleRS: Boolean;
        BoolEdit, boolVisibleRSP : Boolean;

}
