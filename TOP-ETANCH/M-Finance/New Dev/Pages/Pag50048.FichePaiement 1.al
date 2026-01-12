namespace Top.Top;

using Microsoft.Sales.History;
using Microsoft.Sales.Receivables;
using Microsoft.Foundation.NoSeries;
using Microsoft.Sales.Setup;
using Microsoft.Bank.BankAccount;
using Microsoft.Sales.Customer;
using Microsoft.Bank.Payment;

page 50048 "Fiche Paiement"
{
    ApplicationArea = All;
    Caption = 'Fiche Paiement';
    PageType = Card;
    SourceTable = "Sales Invoice Header";

    Permissions = tabledata "Cust. Ledger Entry" = m;


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                group(facture)
                {
                    field("Amount Including VAT"; Rec."Amount Including VAT")
                    {
                        ToolTip = 'Specifies the total of the amounts, including VAT, on all the lines on the document.';
                    }
                    field("Remaining Amount"; Rec."Remaining Amount")
                    {
                        ToolTip = 'Specifies the amount that remains to be paid for the posted sales invoice.';
                    }
                    field("Règlement en cours"; Rec."Règlement en cours")
                    {
                        ToolTip = 'Règlements saisis non encore validés';

                    }
                    field("Bill-to Name"; Rec."Bill-to Name")
                    {
                        ToolTip = 'Specifies the name of the customer that the invoice was sent to.';
                    }

                }
                group(Paiement)
                {
                    Caption = 'General';
                    field(ModalitéPaiement; ModalitéPaiement)
                    {
                    }
                    field(MontantPaiement; MontantPaiement) { }
                    field(DateEchéance; DateEchéance)
                    {
                        trigger OnValidate()
                        var
                            Cust: Record Customer;
                        begin
                            Cust.get(rec."Sell-to Customer No.");
                            if DateEchéance <> 0D then
                                if Cust.EchéanceDépassée(DateEchéance, Rec."Posting Date") then
                                    Message('Attention ! Echéance non resectée ... %1', Cust."Payment Terms Code");

                        end;


                    }

                    field("Banque Client"; BanquePaiement) { }
                    field(PiècePaiement; PiècePaiement) { }

                    field("Notre banque"; CompanyBank)
                    {
                        TableRelation = "Bank Account";
                    }


                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Proposer restant")
            {
                Image = PaymentForecast;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    recL21: Record "Cust. Ledger Entry";
                    PL: Record "Payment Line";

                begin
                    MontantPaiement := 0;
                    recL21.SetCurrentKey("Customer No.", "Posting Date", "Currency Code");
                    recL21.SetRange("Customer No.", Rec."Bill-to Customer No.");
                    recL21.SetRange("Posting Date", rec."Posting Date");
                    recL21.SetRange("Document No.", Rec."No.");
                    recL21.SetRange(Open, true);
                    recL21.SetAutoCalcFields("Remaining Amt. (LCY)");
                    if recL21.FindFirst() then begin
                        MontantPaiement := recL21."Remaining Amt. (LCY)";
                        PL.SetCurrentKey("Facture caisse");
                        PL.SetRange("Facture caisse", Rec."No.");
                        PL.SetRange("Status No.", 0);
                        PL.SetRange("Account No.", rec."Bill-to Customer No.");
                        if PL.FindFirst() then
                            repeat
                                MontantPaiement += PL.Amount;
                            until PL.Next() = 0;
                    end;




                end;


            }
            action("Valider")
            {
                Image = PaymentForecast;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var


                begin


                    CheckPaymentData();
                    InsertPayment();
                    InitPaymentVar();
                    //Rec."Payé" := true;



                end;
            }
        }
    }


    procedure InitPaymentVar()
    begin
        ModalitéPaiement := ModalitéPaiement::" ";
        MontantPaiement := 0;
        PiècePaiement := '';
        BanquePaiement := '';
        DateEchéance := 0D;
        CompanyBank := '';
    end;

    procedure CheckPaymentData()
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



    procedure InsertPayment()
    var
        Doc, NoSerie : Code[20];
        Modalité: Text[20];
        PaymentClass: Record "Payment Class";
        PH: Record "Payment Header";
        CuSeriesNo: Codeunit "No. Series";

        SalesSetup: Record "Sales & Receivables Setup";


    begin
        if ModalitéPaiement = ModalitéPaiement::" " then
            Error('Vous devez spécifier le type de paiement !');

        PaymentClass.SetRange("Type caisse", ModalitéPaiement);
        PaymentClass.FindFirst();

        PH.SetCurrentKey("Posting Date");
        PH.SetRange("Posting Date", Today);
        PH.SetRange("Document Date", Today);
        PH.SetRange("Payment Class", PaymentClass.Code);

        SalesSetup.get;

        NoSerie := 'CAISSE FACT';

        PH.SetRange("No. Series", NoSerie);

        PH.SetRange("Status No.", 0);
        if CompanyBank <> '' then begin
            PH.SetRange("Account No.", CompanyBank);
        end;


        if PH.FindFirst() then
            Doc := PH."No."
        else begin
            PaymentClass.TestField("Header No. Series");
            Doc := CuSeriesNo.GetNextNo(PaymentClass."Header No. Series");
        end;



        InsertPayment(Doc, PaymentClass.Code, NoSerie, CompanyBank);

    end;

    procedure InsertPayment(Doc: Code[20]; Modalité: Text[20]; serie: Code[20]; banque: Code[20])
    var
        PH: Record "Payment Header";
        PL: Record "Payment Line";
        Line: Integer;
        recL21: Record "Cust. Ledger Entry";
    begin
        PH.Init();
        PH."No." := Doc;
        PH."Payment Class" := "Modalité";
        PH.Validate("Posting Date", today);
        PH.Validate("Document Date", today);
        PH."No. Series" := serie;
        if banque <> '' then begin
            PH."Account Type" := PH."Account Type"::"Bank Account";
            PH.validate("Account No.", banque);
        end;
        if PH.insert then;

        PL.SetRange("No.", Doc);
        IF PL.FindLast() then
            Line := PL."Line No.";

        Line += 10000;

        PL.init;
        PL."No." := Doc;
        PL."Payment Class" := "Modalité";
        PL."Line No." := Line;
        PL.Validate("Status No.", 0);
        PL."Account Type" := PL."Account Type"::Customer;
        PL.Validate("Account No.", rec."Sell-to Customer No.");
        IF rec."Sell-to Customer Name 2" <> '' then
            PL.Designation := rec."Sell-to Customer Name 2";
        PL.Validate(Amount, MontantPaiement);
        if "PiècePaiement" <> '' then
            PL.Validate("External Document No.", "PiècePaiement");
        if "DateEchéance" <> 0D then
            PL.Validate("Due Date", "DateEchéance");
        PL."Bank Account Name" := BanquePaiement;
        PL."Posting Date" := today;


        PL."Payment in Progress" := true;





        PL."Facture Caisse" := Rec."No.";
        PL."Applies-to ID" := PL."No." + '/' + format(Pl."Line No.");

        recL21.SetCurrentKey("Document No.");
        recL21.SETFILTER("document no.", rec."No.");
        recL21.SETAUTOCALCFIELDS("Remaining Amt. (LCY)");
        IF recL21.FINDFIRST and recL21.Open THEN BEGIN
            recL21."Applies-to ID" := PL."No." + '/' + format(Pl."Line No.");

            recL21.validate("Amount to Apply", -PL.Amount);

            recL21.MODIFY;
        end;



        PL."Account Type" := PL."Account Type"::Customer;

        PL.Insert();

    end;

    var
        ModalitéPaiement: Option " ",Espèce,Chèque,Traite,Retenue,Virement,TPE,Versement;
        MontantPaiement: Decimal;
        PiècePaiement: Code[30];
        BanquePaiement, CompanyBank : Code[30];
        DateEchéance: Date;
}
