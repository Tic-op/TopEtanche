namespace Top.Top;

using Microsoft.Bank.Payment;

page 50054 ModifierDateEcheance
{
    ApplicationArea = All;
    Caption = 'ModifierDateEcheance';
    PageType = Card;
    SourceTable = "Payment Line";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the payment.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies a document number for the payment line.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the payment line''s entry number.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Payment Class"; Rec."Payment Class")
                {
                    ToolTip = 'Specifies the payment class used when creating this payment slip line.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Status No."; Rec."Status No.")
                {
                    ToolTip = 'Specifies the status line entry number.';
                    ApplicationArea = all;
                    Editable = false;
                }

                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the number of the account that the entry on the journal line will be posted to.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the total amount (including VAT) of the payment line.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the due date on the entry.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(NouvelleDate; NouvelleDate)
                {
                    ApplicationArea = all;

                }
                field("External Document No."; Rec."External Document No.")
                {
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                    ApplicationArea = all;
                    Editable = false;

                }
                field("NouvelleRéference"; "NouvelleRéference")
                {
                    ApplicationArea = all;
                }
                /*field("Copied To No."; Rec."Copied To No.")
                {
                    ApplicationArea = all;
                }
                field("Copied To Line"; Rec."Copied To Line")
                {
                    ApplicationArea = all;
                }
                field(NouveauCopiedNO; NouveauCopiedNO)
                {
                    ApplicationArea = all;
                }
                field(NOUVELLECOPIEDLIGNE; NOUVELLECOPIEDLIGNE)
                {
                    ApplicationArea = all;
                }*/


            }
        }

    }
    actions
    {
        area(processing)
        {
            action(Modifier)
            {
                ApplicationArea = All;
                Caption = 'Modifier';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    UpdatePaymentLine(Rec, NouvelleDate, NouvelleRéference);
                    //UpdatePaymentLine(Rec, NouveauCopiedNO, NOUVELLECOPIEDLIGNE);
                    Close();
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()

    begin
        NouvelleDate := Rec."Due Date";
        NouvelleRéference := Rec."External Document No.";
        //NouveauCopiedNO := Rec."Copied To No.";
        //NOUVELLECOPIEDLIGNE := Rec."Copied To Line";
    end;

    procedure UpdatePaymentLine(var PaymentLine: Record "Payment Line"; NouvelleDate: Date; NouvelleRéference: Code[50] /*NouveauCopiedNO: Code[25]; NOUVELLECOPIEDLIGNE: Integer*/)

    begin

        if NouvelleDate <> PaymentLine."Due Date" then
            PaymentLine.Validate("Due Date", NouvelleDate);
        if NouvelleRéference <> PaymentLine."External Document No." then
            PaymentLine.Validate("External Document No.", NouvelleRéference);
        /*if NouveauCopiedNO <> PaymentLine."Copied To No." then
            PaymentLine.Validate("Copied To No.", NouveauCopiedNO);
        if NOUVELLECOPIEDLIGNE <> PaymentLine."Copied To Line" then
            PaymentLine.Validate("Copied To Line", NOUVELLECOPIEDLIGNE);*/
        PaymentLine.Modify(false);


    end;

    var
        NouvelleDate: Date;
        NouvelleRéference: Code[50];

        NouveauCopiedNO: Code[25];
        NOUVELLECOPIEDLIGNE: Integer;


}
