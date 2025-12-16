namespace Top.Top;
using Microsoft.Purchases.Payables;
using Microsoft.Bank.Payment;
using Microsoft.Sales.History;
using Microsoft.Sales.Receivables;
using Microsoft.Bank.BankAccount;
using Microsoft.Finance.Currency;
using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Sales.Customer;

codeunit 50014 FinanceEvents
{
    EventSubscriberInstance = StaticAutomatic;
    Permissions = tabledata "Vendor Ledger Entry" = m;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Payment Management", 'OnAfterProcessPaymentStep', '', false, false)]
    local procedure ValiderImpayé(PaymentHeaderNo: Code[25]; PaymentStep: Record "Payment Step")
    var
        PL: Record "Payment Line";
        Customer: Record Customer;
        CustomerListToBlock: code[250];
    begin

        if (PaymentStep."Action Type" = PaymentStep."Action Type"::Ledger) and PaymentStep."Impayé Client" then begin
            PL.SetFilter("No.", PaymentHeaderNo);
            PL.SetRange("Account Type", pl."Account Type"::Customer);
            PL.FindFirst();
            repeat
                if CustomerListToBlock = '' then
                    CustomerListToBlock := PL."Account No."
                else
                    CustomerListToBlock := CustomerListToBlock + '|' + PL."Account No.";
            until PL.next = 0;
            Customer.SetFilter("No.", CustomerListToBlock);
            //Customer.ModifyAll(Blocked, Customer.Blocked::Ship);
            Customer.ModifyAll("Cause du blocage", Customer."Cause du blocage"::"Impayé");


            Message('Blocage des comptes clients suivants : %1', CustomerListToBlock);

        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, codeunit::"Payment Management", 'OnAfterProcessPaymentStep', '', false, false)]
    local procedure "Comptabiliser Agios"(PaymentHeaderNo: Code[25]; PaymentStep: Record "Payment Step")
    var

        PH: Record "Payment Header";
        recGLSetup: Record "General Ledger Setup";


    begin


        if NOT PaymentStep."Compta. commission bancaire" AND NOT PaymentStep."Compta. interêt bancaire" then
            exit;
        if PaymentStep."Action Type" <> PaymentStep."Action Type"::Ledger then
            exit;



        PH.get(PaymentHeaderNo);
        recGLSetup.get;



        PH.TestField("Account Type", PH."Account Type"::"Bank Account");
        PH.TestField("Account No.");

        IF PaymentStep."Compta. commission bancaire" AND NOT PH."Is commissioned" then begin
            recGLSetup.TestField("Compte Commission Bancaire");
            recGLSetup.TestField("Compte TVA /Commission");

            ComptabiliserAgios(PaymentHeaderNo, PH.Committees, recGLSetup."Compte Commission Bancaire", 'COMM. BANCAIRE');
            ComptabiliserAgios(PaymentHeaderNo, PH."VAT Committees", recGLSetup."Compte TVA /Commission", 'TVA / COMM. BANCAIRE');
            Message('Commissions et TVA comptabilisées');
            PH.Committees := 0;
            PH."VAT Committees" := 0;
            PH."Is commissioned" := TRUE;
            PH.MODIFY;

        end;

        IF PaymentStep."Compta. interêt bancaire" AND NOT PH.Interest then begin
            recGLSetup.TestField("Compte Interrêt bancaire");
            ComptabiliserAgios(PaymentHeaderNo, PH."Amount Interest (Actual)", recGLSetup."Compte Interrêt bancaire", 'INTERRET BANCAIRE');
            Message('Intêrret comptabilisé');
            PH."Amount Interest (Actual)" := 0;
            PH.Interest := TRUE;
            PH.MODIFY;
        end;

    end;



    [EventSubscriber(ObjectType::Codeunit, codeunit::"Payment Management", 'OnAfterProcessPaymentStep', '', false, false)]
    local procedure "Comptabiliser Différence de change FIND DEV"(PaymentHeaderNo: Code[25]; PaymentStep: Record "Payment Step")
    var

        PH: Record "Payment Header";
        MttDiffChange: Decimal;

    begin


        if not PaymentStep."Comptabiliser Diff. de change" then
            exit;
        if PaymentStep."Action Type" <> PaymentStep."Action Type"::Ledger then
            exit;

        PH.get(PaymentHeaderNo);
        PH.TestField("Currency Code");
        PH.TestField("Currency Factor");

        PH.TestField("Account Type", PH."Account Type"::"Bank Account");
        PH.TestField("Account No.");

        PH.CALCFIELDS("Amount (LCY)");
        MttDiffChange := CalculerMontantFinDev_NonEchu(PaymentHeaderNo) - PH."Amount (LCY)";

        IF MttDiffChange = PH."Amount (LCY)" then // Pas de montant échu pour le Findev
            exit;

        IF MttDiffChange = 0 then //Pas de différence de change à constater
            exit;

        "Comptabliser Diff de Change"(PaymentHeaderNo, MttDiffChange);


    end;


    [EventSubscriber(ObjectType::Codeunit, codeunit::"Payment Management", 'OnAfterProcessPaymentStep', '', false, false)]
    local procedure ValiderRetenueFournisseur(PaymentHeaderNo: Code[25]; PaymentStep: Record "Payment Step")
    var
        PL: Record "Payment Line";

    begin

        if PaymentStep."Comptabiliser RS Fournisseur" = PaymentStep."Comptabiliser RS Fournisseur"::Acune then
            exit;
        if PaymentStep."Action Type" <> PaymentStep."Action Type"::Ledger then
            exit;


        PL.SetFilter("No.", PaymentHeaderNo);
        PL.SetRange("Account Type", pl."Account Type"::Vendor);
        PL.FindFirst();
        repeat
            if PL."Montant RS" <> 0 then begin
                if PaymentStep."Comptabiliser RS Fournisseur" = PaymentStep."Comptabiliser RS Fournisseur"::Validation then
                    ComptabiliserRS(PL."Account No.", PL."Montant RS", PL."Code RS", PL."No.", 1, PL."Line No.")
                else
                    ComptabiliserRS(PL."Account No.", PL."Montant RS", PL."Code RS", PL."No.", -1, PL."Line No.")
            end;

        until PL.next = 0;
    end;

    local procedure ComptabiliserRS(VendorNo: Code[25]; RS_Amount: Decimal; Retenue: Code[25]; Bord: Code[25]; Signe: Integer; LineNo: integer)
    var
        recLRS: Record "Retenue à la source";
        Cpti: Code[20];
        GenJnlLine: Record "Gen. Journal Line";
        PH: Record "Payment Header";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin

        PH.get(Bord);

        IF recLRS.GET("Retenue") THEN
            Cpti := recLRS."Compte GL";

        GenJnlLine.LOCKTABLE;
        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := PH."Posting Date";
        GenJnlLine."Document Date" := PH."Posting Date";

        GenJnlLine.Description := 'Retenue à la source ';
        IF Signe = -1 then
            GenJnlLine.Description := 'Annulation Retenue à la source ';

        GenJnlLine."Sell-to/Buy-from No." := VendorNo;
        GenJnlLine."Bill-to/Pay-to No." := VendorNo;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
        GenJnlLine."Source No." := VendorNo;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := Cpti;
        GenJnlLine."Document No." := Bord;
        GenJnlLine.VALIDATE(GenJnlLine.Amount, -RS_Amount * Signe);
        GenJnlLine."Source Currency Amount" := -RS_Amount * Signe;
        GenJnlLine."Amount (LCY)" := -RS_Amount * Signe;
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Allow Application" := TRUE;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
        GenJnlLine."Source Code" := 'RS FRS';
        GenJnlPostLine.RunWithCheck(GenJnlLine);

        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := PH."Posting Date";
        GenJnlLine."Document Date" := PH."Posting Date";

        GenJnlLine.Description := 'Retenue à la source ';
        IF Signe = -1 then
            GenJnlLine.Description := 'Annulation Retenue à la source ';
        GenJnlLine."Sell-to/Buy-from No." := VendorNo;
        GenJnlLine."Bill-to/Pay-to No." := VendorNo;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
        GenJnlLine."Source No." := VendorNo;



        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
        GenJnlLine.validate("Account No.", VendorNo);      // <<=


        GenJnlLine."Document No." := PH."No.";


        GenJnlLine.VALIDATE(GenJnlLine.Amount, RS_Amount * Signe);
        GenJnlLine."Source Currency Amount" := RS_Amount * Signe;
        GenJnlLine."Amount (LCY)" := RS_Amount * Signe;




        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Allow Application" := TRUE;


        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
        GenJnlLine."Source Code" := 'RS FRS';

        if signe = 1 then begin
            // lettrage RS
            GenJnlLine."Applies-to ID" := Bord + 'RS' + Format(LineNo);
            ApplyVendorInvoice(Bord, LineNo, RS_Amount);
        end;


        GenJnlPostLine.RunWithCheck(GenJnlLine);

    end;

    local procedure ApplyVendorInvoice(Bord: Code[25]; LineNo: Integer; MttLettrage: Decimal)
    var
        VendorLedgerEntries: Record "Vendor Ledger Entry";
        D_VendorLedgerEntries: Record "Detailed Vendor Ledg. Entry";
        ListVendorEntryNos: Text;
        PayLine: Record "payment line";
        DocNoApply: Code[20];
        DateApply: Date;
        ApplicationNo: Integer;
        RestantMttLettrage: Decimal;

    begin
        PayLine.get(Bord, LineNo);
        if PayLine."Entry No. Debit" = 0 then
            exit;
        if not VendorLedgerEntries.GET(PayLine."Entry No. Debit") then
            exit;

        D_VendorLedgerEntries.SetCurrentKey("Vendor Ledger Entry No.", "Posting Date");
        D_VendorLedgerEntries.SetRange("Vendor Ledger Entry No.", PayLine."Entry No. Debit");
        D_VendorLedgerEntries.SetRange("entry Type", D_VendorLedgerEntries."entry Type"::Application);
        if not D_VendorLedgerEntries.FindFirst() then
            exit;
        DocNoApply := D_VendorLedgerEntries."Document No.";
        DateApply := D_VendorLedgerEntries."Posting Date";
        ApplicationNo := D_VendorLedgerEntries."Application No.";

        D_VendorLedgerEntries.Reset();
        D_VendorLedgerEntries.SetCurrentKey("Application No.", "Vendor No.", "Entry Type");
        D_VendorLedgerEntries.SetFilter("Vendor No.", PayLine."Account No.");
        D_VendorLedgerEntries.SetRange("Entry Type", D_VendorLedgerEntries."Entry Type"::Application);
        D_VendorLedgerEntries.SetRange("Application No.", ApplicationNo);
        D_VendorLedgerEntries.SetFilter("Document No.", DocNoApply);
        D_VendorLedgerEntries.SetRange("Posting Date", DateApply);

        D_VendorLedgerEntries.SetFilter("Vendor Ledger Entry No.", '<>%1', PayLine."Entry No. Debit");
        if D_VendorLedgerEntries.FindFirst() then
            repeat
                if ListVendorEntryNos = '' then
                    ListVendorEntryNos := Format(D_VendorLedgerEntries."Vendor Ledger Entry No.")
                else
                    ListVendorEntryNos := ListVendorEntryNos + '|' + format(D_VendorLedgerEntries."Vendor Ledger Entry No.");
            until D_VendorLedgerEntries.Next() = 0;

        if ListVendorEntryNos = '' then
            exit;


        RestantMttLettrage := MttLettrage;
        VendorLedgerEntries.SetFilter("Entry No.", ListVendorEntryNos);
        VendorLedgerEntries.SetRange(Positive, false);
        VendorLedgerEntries.SetAutoCalcFields("Remaining Amt. (LCY)");
        VendorLedgerEntries.FindFirst();
        repeat
            if VendorLedgerEntries.open then begin
                VendorLedgerEntries."Applies-to ID" := Bord + 'RS' + Format(LineNo);
                if abs(VendorLedgerEntries."Remaining Amt. (LCY)") >= RestantMttLettrage then begin
                    VendorLedgerEntries.validate("Amount to Apply", -RestantMttLettrage);
                    RestantMttLettrage := 0;
                end
                else begin
                    VendorLedgerEntries.validate("Amount to Apply", VendorLedgerEntries."Remaining Amt. (LCY)");
                    RestantMttLettrage -= ABS(VendorLedgerEntries."Remaining Amt. (LCY)");
                end;

                VendorLedgerEntries.Modify();

            end;
        until (VendorLedgerEntries.Next() = 0) or (RestantMttLettrage = 0);


    end;





    local procedure CalculerMontantFinDev_NonEchu(PaymentHeaderNo: Code[20]): Decimal
    var
        recL17: Record "G/L Entry";

        recGLSetup: Record "General Ledger Setup";

    begin
        recGLSetup.get;
        recGLSetup.TESTFIELD("Compte Fin. dev.");
        recL17.SetCurrentKey("G/L Account No.", "Document No.", "Posting Date");
        recL17.SETFILTER("G/L Account No.", recGLSetup."Compte Fin. dev.");
        recL17.SETFILTER("Document No.", PaymentHeaderNo);
        recL17.SetFilter(Amount, '<0');


        IF recL17.FINDFIRST THEN
            exit(-recL17.Amount);

        Message('Pas de Mtt Fin. Dev. Non Echu dans le filtre suivant :\%1', recL17.GetFilters);

    end;



    local procedure "Comptabliser Diff de Change"(PaymentHeaderNo: Code[20]; MttDiffChange: Decimal)
    var
        recGLSetup: Record "General Ledger Setup";
        PH: Record "Payment Header";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        recCurrency: Record Currency;
        Cperte: Code[20];
        Cgain: Code[20];
    begin
        PH.get(PaymentHeaderNo);
        PH.CALCFIELDS(Amount);
        recGLSetup.get;
        recGLSetup.TESTFIELD("Compte Fin. dev.");



        IF recCurrency.GET(PH."Currency Code") THEN BEGIN
            recCurrency.TESTFIELD("Realized Gains Acc.");
            recCurrency.TESTFIELD(recCurrency."Realized Losses Acc.");
            Cperte := recCurrency."Realized Losses Acc.";
            Cgain := recCurrency."Realized Gains Acc.";
        END;



        IF MttDiffChange < 0 THEN BEGIN //Perte de change ==>     Cperte|Fin Dev
            GenJnlLine.INIT;
            GenJnlLine."Posting Date" := PH."Posting Date";
            GenJnlLine."Document Date" := PH."Document Date";
            GenJnlLine.Description := 'Perte de change Fin. Dev Echu ' + Format(PH.Amount) + ' ' + PH."Currency Code";
            GenJnlLine."Shortcut Dimension 1 Code" := PH."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := PH."Shortcut Dimension 2 Code";
            GenJnlLine."Dimension Set ID" := PH."Dimension Set ID";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := Cperte;
            GenJnlLine."Document No." := PH."No.";
            GenJnlLine.VALIDATE(GenJnlLine.Amount, -MttDiffChange);
            GenJnlLine."Amount (LCY)" := -MttDiffChange;
            GenJnlLine."Currency Factor" := 1;
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Allow Application" := TRUE;
            GenJnlLine."Source Code" := 'OD';
            GenJnlPostLine.RunWithCheck(GenJnlLine);


            // Credit Fin dev
            GenJnlLine.INIT;
            GenJnlLine."Posting Date" := PH."Posting Date";
            GenJnlLine."Document Date" := PH."Document Date";
            GenJnlLine.Description := 'Perte de change Fin. Dev Echu ' + Format(PH.Amount) + ' ' + PH."Currency Code";
            GenJnlLine."Shortcut Dimension 1 Code" := PH."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := PH."Shortcut Dimension 2 Code";
            GenJnlLine."Dimension Set ID" := PH."Dimension Set ID";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := recGLSetup."Compte Fin. dev.";       // <<=
            GenJnlLine."Document No." := PH."No.";
            GenJnlLine.VALIDATE(GenJnlLine.Amount, MttDiffChange);
            GenJnlLine."Amount (LCY)" := MttDiffChange;
            GenJnlLine."Currency Factor" := 1;
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Allow Application" := TRUE;
            GenJnlLine."Source Code" := 'OD';
            GenJnlPostLine.RunWithCheck(GenJnlLine);
        END
        ELSE BEGIN
            //Gains de change ==>     Fin Dev|CGain
            GenJnlLine.INIT;
            GenJnlLine."Posting Date" := PH."Posting Date";
            GenJnlLine."Document Date" := PH."Document Date";
            GenJnlLine.Description := 'Gains de change Fin. Dev Echu ' + Format(PH.Amount) + ' ' + PH."Currency Code";
            GenJnlLine."Shortcut Dimension 1 Code" := PH."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := PH."Shortcut Dimension 2 Code";
            GenJnlLine."Dimension Set ID" := PH."Dimension Set ID";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := recGLSetup."Compte Fin. dev.";      // <<=
            GenJnlLine."Document No." := PH."No.";
            GenJnlLine.VALIDATE(GenJnlLine.Amount, MttDiffChange);
            GenJnlLine."Amount (LCY)" := MttDiffChange;
            GenJnlLine."Currency Factor" := 1;
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Allow Application" := TRUE;
            GenJnlLine."Source Code" := 'OD';
            GenJnlPostLine.RunWithCheck(GenJnlLine);




            // Credit 506
            GenJnlLine.INIT;
            GenJnlLine."Posting Date" := PH."Posting Date";
            GenJnlLine."Document Date" := PH."Document Date";
            GenJnlLine.Description := 'Gains de change Fin. Dev Echu ' + Format(PH.Amount) + ' ' + PH."Currency Code";
            GenJnlLine."Shortcut Dimension 1 Code" := PH."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := PH."Shortcut Dimension 2 Code";
            GenJnlLine."Dimension Set ID" := PH."Dimension Set ID";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := Cgain;      // <<=
            GenJnlLine."Document No." := PH."No.";
            GenJnlLine.VALIDATE(GenJnlLine.Amount, -MttDiffChange);
            GenJnlLine."Amount (LCY)" := -MttDiffChange;
            GenJnlLine."Currency Factor" := 1;
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Allow Application" := TRUE;
            GenJnlLine."Source Code" := 'OD';
            GenJnlPostLine.RunWithCheck(GenJnlLine);

        end;
    end;



    local procedure ComptabiliserAgios(PaymentHeaderNo: Code[20]; MttAgios: Decimal; DebitAccount: Code[20]; Description: Text)
    var
        PH: Record "Payment Header";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        recBank: Record "Bank Account";

    begin
        IF MttAgios <= 0 then
            Error('Montant agios doit avoir une valeur positive !');

        PH.get(PaymentHeaderNo);
        PH.TestField("Account Type", PH."Account Type"::"Bank Account");
        PH.TESTFIELD("Account No.");

        recBank.get(PH."Account No.");
        recBank.testfield(Journal);

        GenJnlLine.LOCKTABLE;
        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := PH."Posting Date";
        GenJnlLine."Document Date" := PH."Document Date";

        GenJnlLine.Description := Description;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Finance Charge Memo";
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::"Bank Account";
        GenJnlLine."Source No." := PH."Account No.";
        GenJnlLine."Shortcut Dimension 1 Code" := PH."Shortcut Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := PH."Shortcut Dimension 2 Code";
        GenJnlLine."Dimension Set ID" := PH."Dimension Set ID";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := DebitAccount;      // <<=
        GenJnlLine."Document No." := PH."No.";

        GenJnlLine.VALIDATE(GenJnlLine.Amount, MttAgios);
        GenJnlLine."Source Currency Amount" := MttAgios;
        GenJnlLine."Amount (LCY)" := MttAgios;
        IF PH."Currency Code" = '' THEN
            GenJnlLine."Currency Factor" := 1
        ELSE
            GenJnlLine."Currency Factor" := PH."Currency Factor";

        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Allow Application" := TRUE;

        GenJnlLine."Source Code" := recBank.Journal; //"Source Code" ;
        GenJnlPostLine.RunWithCheck(GenJnlLine);


        // Le Credit : BQ


        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := PH."Posting Date";
        GenJnlLine."Document Date" := PH."Document Date";

        GenJnlLine.Description := Description;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Finance Charge Memo";

        GenJnlLine."Source Type" := GenJnlLine."Source Type"::"Bank Account";
        GenJnlLine."Source No." := PH."Account No.";


        GenJnlLine."Shortcut Dimension 1 Code" := PH."Shortcut Dimension 1 Code";

        GenJnlLine."Dimension Set ID" := PH."Dimension Set ID";

        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
        GenJnlLine."Account No." := PH."Account No.";      // <<=
        GenJnlLine."Document No." := PH."No.";

        GenJnlLine.VALIDATE(GenJnlLine.Amount, -MttAgios);
        GenJnlLine."Source Currency Amount" := -MttAgios;
        GenJnlLine."Amount (LCY)" := -MttAgios;
        IF PH."Currency Code" = '' THEN
            GenJnlLine."Currency Factor" := 1
        ELSE
            GenJnlLine."Currency Factor" := PH."Currency Factor";



        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Allow Application" := TRUE;


        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
        GenJnlLine."Source Code" := recBank.Journal;
        GenJnlPostLine.RunWithCheck(GenJnlLine);


    end;



    ////////******************Retenue à la source Client : Constatation de la TVA*******************
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Payment Management", 'OnBeforeProcessPaymentStep', '', false, false)]



    local procedure ValiderTVARetenueClientPublique(PaymentHeaderNo: Code[25]; PaymentStep: Record "Payment Step")
    var
        PL: Record "Payment Line";
        InvoiceVAT_Amount: Decimal;
        CLE: Record "Cust. Ledger Entry";
        PostedInvoice: Record "Sales Invoice Header";
        GLSetup: Record "General Ledger Setup";
        PH: Record 10865;

    begin

        if PaymentStep."Comptabiliser TVA RS Publique" = PaymentStep."Comptabiliser TVA RS Publique"::Acune then
            exit;
        if PaymentStep."Action Type" <> PaymentStep."Action Type"::Ledger then
            exit;

        PH.get(PaymentHeaderNo);
        PH.TestField("Source Code");
        GLSetup.get();
        PL.SetFilter("No.", PaymentHeaderNo);
        PL.SetRange("Account Type", pl."Account Type"::Customer);
        PL.FindFirst();
        repeat


            if PaymentStep."Comptabiliser TVA RS Publique" = PaymentStep."Comptabiliser TVA RS Publique"::Validation then
                ComptabiliserRS_Client_Publique(PL."Account No.", PL."No.", 1, PL."Line No.", PL."TVA RS Pub"); //InvoiceVAT_Amount

        until PL.next = 0;

    end;


    local procedure ComptabiliserRS_Client_Publique(CustomerNo: Code[25]; Bord: Code[25]; Signe: Integer; LineNo: integer; VAT_Amount: Decimal)
    var

        Cpti: Code[20];
        GenJnlLine: Record "Gen. Journal Line";
        PH: Record "Payment Header";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GLSetup: Record "General Ledger Setup";
        Customer: Record Customer;
        PL: Record "Payment Line";

    begin



        Customer.get(CustomerNo);
        //if Customer.Timbre THEN 
        //  Error('Le client %1 n''est pas publique',CustomerNo);

        if Customer."Currency Code" <> '' THEN
            Error('Le client %1 n''est pas publique', CustomerNo);


        PH.get(Bord);
        GLSetup.get();
        // GLSetup.TestField("TVA RS Publique");
        GLSetup.TestField("Compte TVA RS Publique");
        PL.SetFilter("No.", Bord);
        PL.SetRange("Account Type", pl."Account Type"::Customer);
        if PL.FindFirst() then
            VAT_Amount := pl."TVA RS Pub";


        Cpti := GLSetup."Compte TVA RS Publique";

        GenJnlLine.LOCKTABLE;
        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := PH."Posting Date";
        GenJnlLine."Document Date" := PH."Posting Date";

        GenJnlLine.Description := 'TVA Retenue publique ';
        IF Signe = -1 then
            GenJnlLine.Description := 'Annulation TVA Retenue publique ';

        GenJnlLine."Sell-to/Buy-from No." := CustomerNo;
        GenJnlLine."Bill-to/Pay-to No." := CustomerNo;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
        GenJnlLine."Source No." := CustomerNo;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := Cpti;
        GenJnlLine."Document No." := Bord;
        GenJnlLine.VALIDATE(GenJnlLine.Amount, VAT_Amount * Signe);
        GenJnlLine."Source Currency Amount" := VAT_Amount * Signe;
        GenJnlLine."Amount (LCY)" := VAT_Amount * Signe;
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Allow Application" := TRUE;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
        GenJnlLine."Source Code" := 'RS CLT';
        GenJnlPostLine.RunWithCheck(GenJnlLine);

        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := PH."Posting Date";
        GenJnlLine."Document Date" := PH."Posting Date";

        GenJnlLine.Description := 'Retenue à la source ';
        IF Signe = -1 then
            GenJnlLine.Description := 'Annulation Retenue à la source ';
        GenJnlLine."Sell-to/Buy-from No." := CustomerNo;
        GenJnlLine."Bill-to/Pay-to No." := CustomerNo;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
        GenJnlLine."Source No." := CustomerNo;



        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine.validate("Account No.", CustomerNo);


        GenJnlLine."Document No." := PH."No.";


        GenJnlLine.VALIDATE(GenJnlLine.Amount, -VAT_Amount * Signe);
        GenJnlLine."Source Currency Amount" := -VAT_Amount * Signe;
        GenJnlLine."Amount (LCY)" := -VAT_Amount * Signe;




        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Allow Application" := TRUE;


        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
        GenJnlLine."Source Code" := 'RS CLT';




        GenJnlPostLine.RunWithCheck(GenJnlLine);

    end;
    /* local procedure ValiderTVARetenueClientPublique(PaymentHeaderNo: Code[25]; PaymentStep: Record "Payment Step")
     var
         PL: Record "Payment Line";
         InvoiceVAT_Amount: Decimal;
         CLE: Record "Cust. Ledger Entry";
         PostedInvoice: Record "Sales Invoice Header";
         GLSetup: Record "General Ledger Setup";
         PH: Record 10865;

     begin

         if PaymentStep."Comptabiliser TVA RS Publique" = PaymentStep."Comptabiliser TVA RS Publique"::Acune then
             exit;
         if PaymentStep."Action Type" <> PaymentStep."Action Type"::Ledger then
             exit;

         PH.get(PaymentHeaderNo);
         PH.TestField("Source Code");
         GLSetup.get();
         PL.SetFilter("No.", PaymentHeaderNo);
         PL.SetRange("Account Type", pl."Account Type"::Customer);
         PL.FindFirst();
         repeat

             InvoiceVAT_Amount := 0;

             if PL."Applies-to ID" = '' THEN
                 Error('La ligne %1 n''a pas de lettrage');

             CLE.SetCurrentKey("Customer No.", "Applies-to ID", Open, Positive, "Due Date");
             CLE.SetRange("Customer No.", PL."Account No.");
             CLE.SetRange("Applies-to ID", PL."Applies-to ID");
             CLE.SetRange("Document Type", CLE."Document Type"::Invoice);
             CLE.findfirst; // Voir la possibilité de payer pls factures d'un seul coup !!
             repeat
                 PostedInvoice.get(CLE."Document No.");
                 PostedInvoice.CalcFields("Amount Including VAT", Amount);

                 InvoiceVAT_Amount += PostedInvoice."Amount Including VAT" - PostedInvoice.Amount;

             until CLE.next = 0;
             if PaymentStep."Comptabiliser TVA RS Publique" = PaymentStep."Comptabiliser TVA RS Publique"::Validation then
                 ComptabiliserRS_Client_Publique(PL."Account No.", PL."No.", 1, PL."Line No.", InvoiceVAT_Amount);

             PL."RS VAT Amount" := InvoiceVAT_Amount;
             PL."Montant RS VAT Amount" := InvoiceVAT_Amount;//-InvoiceVAT_Amount ;//* GLSetup."TVA RS Publique" ;
             PL.Validate(Amount, ROUND(PL.Amount / 100, 0.001, '='));
             PL."Montant RS VAT Amount" := ROUND(InvoiceVAT_Amount * GLSetup."TVA RS Publique" / 100, 0.001, '=');
             PL.Modify();


         until PL.next = 0;

     end;*/







    /*local procedure ComptabiliserRS_Client_Publique(CustomerNo: Code[25]; Bord: Code[25]; Signe: Integer; LineNo: integer; VAT_Amount: Decimal)
    var

        Cpti: Code[20];
        GenJnlLine: Record "Gen. Journal Line";
        PH: Record "Payment Header";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GLSetup: Record "General Ledger Setup";
        Customer: Record Customer;

    begin



        Customer.get(CustomerNo);
        //if Customer.Timbre THEN 
        //  Error('Le client %1 n''est pas publique',CustomerNo);

        if Customer."Currency Code" <> '' THEN
            Error('Le client %1 n''est pas publique', CustomerNo);


        PH.get(Bord);
        GLSetup.get();
        GLSetup.TestField("TVA RS Publique");
        GLSetup.TestField("Compte TVA RS Publique");
        VAT_Amount := ROUND(VAT_Amount * GLSetup."TVA RS Publique" / 100, 0.001, '=');

        Cpti := GLSetup."Compte TVA RS Publique";

        GenJnlLine.LOCKTABLE;
        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := PH."Posting Date";
        GenJnlLine."Document Date" := PH."Posting Date";

        GenJnlLine.Description := 'TVA Retenue publique ';
        IF Signe = -1 then
            GenJnlLine.Description := 'Annulation TVA Retenue publique ';

        GenJnlLine."Sell-to/Buy-from No." := CustomerNo;
        GenJnlLine."Bill-to/Pay-to No." := CustomerNo;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
        GenJnlLine."Source No." := CustomerNo;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := Cpti;
        GenJnlLine."Document No." := Bord;
        GenJnlLine.VALIDATE(GenJnlLine.Amount, VAT_Amount * Signe);
        GenJnlLine."Source Currency Amount" := VAT_Amount * Signe;
        GenJnlLine."Amount (LCY)" := VAT_Amount * Signe;
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Allow Application" := TRUE;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
        GenJnlLine."Source Code" := 'RS CLT';
        GenJnlPostLine.RunWithCheck(GenJnlLine);

        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := PH."Posting Date";
        GenJnlLine."Document Date" := PH."Posting Date";

        GenJnlLine.Description := 'Retenue à la source ';
        IF Signe = -1 then
            GenJnlLine.Description := 'Annulation Retenue à la source ';
        GenJnlLine."Sell-to/Buy-from No." := CustomerNo;
        GenJnlLine."Bill-to/Pay-to No." := CustomerNo;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
        GenJnlLine."Source No." := CustomerNo;



        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine.validate("Account No.", CustomerNo);      // <<=


        GenJnlLine."Document No." := PH."No.";


        GenJnlLine.VALIDATE(GenJnlLine.Amount, -VAT_Amount * Signe);
        GenJnlLine."Source Currency Amount" := -VAT_Amount * Signe;
        GenJnlLine."Amount (LCY)" := -VAT_Amount * Signe;




        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Allow Application" := TRUE;


        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
        GenJnlLine."Source Code" := 'RS CLT';




        GenJnlPostLine.RunWithCheck(GenJnlLine);

    end;*/

    procedure CopyParamsPaymentStatus(SourceCompany: Text[20]; TargetCompany: Text[20])
    var
        ParamRec: Record 10861;
        TargetParamRec: Record 10861;
        Copié: Integer;
        Skipped: Integer;
    begin
        Copié := 0;
        Skipped := 0;

        // Lire les paramètres de la société source
        ParamRec.ChangeCompany(SourceCompany);

        if ParamRec.FindSet() then begin
            repeat
                // Appliquer ChangeCompany pour la société cible
                TargetParamRec.ChangeCompany(TargetCompany);

                // Vérifier si l'enregistrement existe déjà

                if not TargetParamRec.Get(ParamRec."Payment Class", ParamRec.Line) then begin
                    TargetParamRec.INIT;
                    TargetParamRec := ParamRec;
                    TargetParamRec.INSERT(false);
                    Copié += 1;
                end else begin
                    Skipped += 1;
                end;
            until ParamRec.Next() = 0;

            Message('Copie terminée : %1 enregistrements copiés, %2 déjà existants.', Copié, Skipped);
        end else begin
            Message('Aucun paramètre trouvé dans la société source.');
        end;
    end;

    procedure CopyParamsPaymentClass(SourceCompany: Text[20]; TargetCompany: Text[20])
    var
        ParamRec: Record 10860;
        TargetParamRec: Record 10860;
        Copié: Integer;
        Skipped: Integer;
    begin
        Copié := 0;
        Skipped := 0;

        // Lire les paramètres de la société source
        ParamRec.ChangeCompany(SourceCompany);

        if ParamRec.FindSet() then begin
            repeat
                // Appliquer ChangeCompany pour la société cible
                TargetParamRec.ChangeCompany(TargetCompany);

                // Vérifier si l'enregistrement existe déjà
                if not TargetParamRec.Get(ParamRec.Code) then begin
                    TargetParamRec.INIT;
                    TargetParamRec := ParamRec;
                    TargetParamRec.INSERT(false);
                    Copié += 1;
                end else begin
                    Skipped += 1;
                end;
            until ParamRec.Next() = 0;

            Message('Copie terminée : %1 enregistrements copiés, %2 déjà existants.', Copié, Skipped);
        end else begin
            Message('Aucun paramètre trouvé dans la société source.');
        end;
    end;

    procedure CopyParamsPaymentStep(SourceCompany: Text[20]; TargetCompany: Text[20])
    var
        ParamRec: Record 10862;
        TargetParamRec: Record 10862;
        Copié: Integer;
        Skipped: Integer;
    begin
        Copié := 0;
        Skipped := 0;

        // Lire les paramètres de la société source
        ParamRec.ChangeCompany(SourceCompany);

        if ParamRec.FindSet() then begin
            repeat
                // Appliquer ChangeCompany pour la société cible
                TargetParamRec.ChangeCompany(TargetCompany);

                // Vérifier si l'enregistrement existe déjà
                if not TargetParamRec.Get(ParamRec."Payment Class", ParamRec.Line) then begin
                    TargetParamRec.INIT;
                    TargetParamRec := ParamRec;
                    TargetParamRec.INSERT(false);
                    Copié += 1;
                end else begin
                    Skipped += 1;
                end;
            until ParamRec.Next() = 0;

            Message('Copie terminée : %1 enregistrements copiés, %2 déjà existants.', Copié, Skipped);
        end else begin
            Message('Aucun paramètre trouvé dans la société source.');
        end;
    end;

    procedure CopyParamsPaymentStepLedger(SourceCompany: Text[20]; TargetCompany: Text[20])
    var
        ParamRec: Record 10863;
        TargetParamRec: Record 10863;
        Copié: Integer;
        Skipped: Integer;
    begin
        Copié := 0;
        Skipped := 0;

        // Lire les paramètres de la société source
        ParamRec.ChangeCompany(SourceCompany);

        if ParamRec.FindSet() then begin
            repeat
                // Appliquer ChangeCompany pour la société cible
                TargetParamRec.ChangeCompany(TargetCompany);

                // Vérifier si l'enregistrement existe déjà
                if not TargetParamRec.Get(ParamRec."Payment Class", ParamRec.Line, ParamRec.Sign) then begin
                    TargetParamRec.INIT;
                    TargetParamRec := ParamRec;
                    TargetParamRec.INSERT(false);
                    Copié += 1;
                end else begin
                    Skipped += 1;
                end;
            until ParamRec.Next() = 0;

            Message('Copie terminée : %1 enregistrements copiés, %2 déjà existants.', Copié, Skipped);
        end else begin
            Message('Aucun paramètre trouvé dans la société source.');
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Payment Line", OnBeforeModifyEvent, '', false, false)] //IS200825
    local procedure ModifyDueDate(var Rec: Record "Payment Line"; xRec: Record "Payment Line")
    begin
        if xRec."Due Date" <> Rec."Due Date" then begin
            Rec."Due Date" := xRec."Due Date";
            Rec.Validate("Due Date");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Payment Management", OnBeforeProcessPaymentStep, '', false, false)]
    local procedure AssignSourceCode(PaymentHeaderNo: Code[25]; PaymentStep: Record "Payment Step")
    var

        Bank: Record "Bank Account";
        PH: Record "Payment Header";
        PC: Record "Payment Class";
        PL: Record "Payment Line";

    begin

        PH.get(PaymentHeaderNo);
        if PH."Status No." = 0 then begin
            PC.Get(PH."Payment Class");
            if PC."Sans Echéance" then begin
                PL.SetFilter("No.", PaymentHeaderNo);
                PL.ModifyAll("Due Date", PH."Posting Date");
            end;
        end;

    end;


}



