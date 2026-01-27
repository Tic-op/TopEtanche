namespace Top.Top;
using Microsoft.Sales.History;
using Microsoft.Bank.BankAccount;
using Microsoft.Bank.Payment;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.VAT.Ledger;

page 50049 "Fiche Paiement BL"
{
    ApplicationArea = All;
    Caption = 'Fiche Paiement BL';
    PageType = Card;
    SourceTable = "Sales Shipment Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("BL No."; ShipmentNo) { Editable = false; }
                field("Client"; CustomerName) { Editable = false; }
                field("Montant BL TTC"; AmountBL) { Editable = false; }
                field("Règlement en cours"; rec."Règlement en cours") { Editable = false; }

            }

            group(Paiement)
            {
                field("Modalité Paiement"; ModalitéPaiement) { }
                field("Montant Paiement"; MontantPaiement) { }
                field("Date Echéance"; DateEchéance) { }
                field("Banque Client"; BanquePaiement) { }
                field("Pièce Paiement"; PiècePaiement) { }
                field("Banque Société"; CompanyBank)
                {
                    TableRelation = "Bank Account";
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Proposer montant BL")
            {
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    MontantPaiement := AmountBL + rec."Règlement en cours";
                end;
            }

            action("Valider")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CheckPaymentData();
                    InsertPaymentFromBL();
                    InitPaymentVar();
                    Message('Paiement BL enregistré avec succès');
                end;
            }
        }
    }

    local procedure InitPaymentVar()
    begin
        ModalitéPaiement := ModalitéPaiement::" ";
        MontantPaiement := 0;
        PiècePaiement := '';
        BanquePaiement := '';
        DateEchéance := 0D;
        CompanyBank := '';
    end;

    local procedure CheckPaymentData()
    begin
        IF ModalitéPaiement = ModalitéPaiement::" " then
            Error('Sélectionnez une modalité de paiement ');
        if MontantPaiement <= 0 then
            Error('Problème de montant de paiement');

        if ModalitéPaiement = ModalitéPaiement::Traite then begin
            if PiècePaiement = '' then
                Error('Problème de pièce de paiement');

            if BanquePaiement = '' then
                Error('Problème de banque de paiement');

            if DateEchéance = 0D THEN
                Error('Problème de Date échéance de paiement');
        end;

        if (ModalitéPaiement = ModalitéPaiement::"Chèque") OR (ModalitéPaiement = ModalitéPaiement::"Virement") then begin
            if PiècePaiement = '' then
                Error('Problème de pièce de paiement');

            if BanquePaiement = '' then
                Error('Problème de banque de paiement');
        end;

        if (ModalitéPaiement = ModalitéPaiement::"Virement") or (ModalitéPaiement = ModalitéPaiement::"Versement") then begin
            if CompanyBank = '' then
                Error('Problème de banque %1', CompanyName);
        end;

    end;


    local procedure InsertPaymentFromBL()
    var
        PH: Record "Payment Header";
        PL: Record "Payment Line";
        PaymentClass: Record "Payment Class";
        NoSeries: Codeunit "No. Series";
        DocNo: Code[20];
        LineNo: Integer;

    begin
        PaymentClass.SetRange("Type caisse", ModalitéPaiement);
        PaymentClass.FindFirst();

        // 1 header / jour / modalité / banque
        PH.SetRange("Posting Date", Today);
        PH.SetRange("Payment Class", PaymentClass.Code);
        PH.SetRange("Status No.", 0);



        PH.SetRange("No. Series", 'CAISSE BL');
        if CompanyBank <> '' then
            PH.SetRange("Account No.", CompanyBank);

        if PH.FindFirst() then
            DocNo := PH."No."
        else begin
            DocNo := NoSeries.GetNextNo(PaymentClass."Header No. Series");
            PH.Init();
            PH."No." := DocNo;
            PH."Payment Class" := PaymentClass.Code;
            PH."No. Series" := 'CAISSE BL';
            PH.Validate("Posting Date", Today);
            if CompanyBank <> '' then begin
                PH."Account Type" := PH."Account Type"::"Bank Account";
                PH.validate("Account No.", CompanyBank);
            end;
            PH.Insert();
        end;

        // Ligne
        PL.SetRange("No.", DocNo);
        if PL.FindLast() then
            LineNo := PL."Line No.";
        LineNo += 10000;

        PL.Init();
        PL."No." := DocNo;
        PL."Line No." := LineNo;
        PL."Payment Class" := PaymentClass.Code;
        PL."Account Type" := PL."Account Type"::Customer;
        PL.Validate("Account No.", CustomerNo);
        IF rec."Sell-to Customer Name 2" <> '' then
            PL.Designation := rec."Sell-to Customer Name 2";
        PL.Validate(Amount, MontantPaiement);
        if "PiècePaiement" <> '' then
            PL.Validate("External Document No.", "PiècePaiement");
        if "DateEchéance" <> 0D then
            PL.Validate("Due Date", "DateEchéance");
        PL."Bank Account Name" := BanquePaiement;

        PL."Posting Date" := Today;

        PL."Facture Caisse" := ShipmentNo; // champ custom
        PL."Payment in Progress" := true;

        PL.Insert();
    end;

    procedure SetShipment(PSH: Record "Sales Shipment Header")
    begin
        rec.SetRange("No.", PSH."No.");
        ShipmentNo := PSH."No.";
        CustomerNo := PSH."Sell-to Customer No.";
        CustomerName := PSH."Sell-to Customer Name";
        AmountBL := CalcShipmentAmount(PSH."No.");
    end;

    local procedure CalcShipmentAmount(ShipmentNo: Code[20]) MttTTC: Decimal
    var

        ShipLine: Record "Sales Shipment Line";
    begin
        ShipLine.SetRange("Document No.", ShipmentNo);
        ShipLine.FindSet();
        repeat
            MttTTC += ShipLine.Quantity * ShipLine."Unit Price" * (1 - ShipLine."Line Discount %" / 100) * (1 + ShipLine."VAT %" / 100);
            if ShipLine."Quantity Invoiced" <> 0 then
                Error('Attention !! BL facturé');
        until ShipLine.next = 0;
        exit(ROUND(MttTTC, 0.001, '='));
    end;

    var
        ShipmentNo: Code[20];
        CustomerNo: Code[20];
        CustomerName: Text[100];
        AmountBL: Decimal;

        ModalitéPaiement: Option " ",Espèce,Chèque,Traite,Retenue,Virement,TPE,Versement;
        MontantPaiement: Decimal;
        BanquePaiement: Code[30];
        CompanyBank, PiècePaiement : Code[30];
        DateEchéance: Date;

}
