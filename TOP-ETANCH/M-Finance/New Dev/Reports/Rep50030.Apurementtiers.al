namespace Top.Top;
using Microsoft.Sales.Receivables;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Sales.Customer;
using Microsoft.Purchases.Payables;
using System.Utilities;
using Microsoft.Inventory.Counting.Journal;

report 50030 Apurement
{
    ApplicationArea = All;
    Caption = 'Apurement';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Cust. Ledger Entry"; Integer)
        {
            DataItemTableView = SORTING(Number)
                                 WHERE(Number = FILTER(1));

            trigger OnPreDataItem()
            begin
                //  if (apurClient and apurFrns) or (not apurClient and not apurFrns) then
                //    Error('Vous devez sélectionner un type tiers !!!');
            end;

            trigger OnAfterGetRecord()
            var
                GenJnlLine: Record "Gen. Journal Line";

                GenJnlBatch: Record "Gen. Journal Batch";
                recGLSetup: Record "General Ledger Setup";
                mtt: Decimal;
                Doc: Code[50];
                line: Integer;
                NoSeriesMgt: Codeunit "No. Series";
                DocumentNo: Code[25];
                recL21: Record "Cust. Ledger Entry";
                GenJnlTemplate: Record "Gen. Journal Template";
                journal: Code[10];
                feuille: Code[10];
                recL18: Record Customer;
                recL25: Record "Vendor Ledger Entry";
            begin

                if not apurClient then begin // must be apurClient
                    // recL21.Get("Entry No.");
                    if (mtt0 > 0) or (mtt1 < 0) or (DateC = 0D) then
                        Error('Vérifiez les montants et/ou la date');
                    journal := 'OD';
                    feuille := 'OD';

                    recGLSetup.FIND;
                    recGLSetup.TestField("Gains écr. apurement");
                    recGLSetup.TestField("Pertes écr. apurement");

                    GenJnlTemplate.GET(feuille);
                    GenJnlBatch.SETFILTER("Journal Template Name", GenJnlTemplate.Name);
                    GenJnlBatch.FINDFIRST;


                    GenJnlLine.SetRange("Journal Template Name", 'OD');
                    GenJnlLine.SetRange("Journal Batch Name", 'OD');
                    //if GenJnlLine.FindLast() then
                    //Error('Vous devez supprimer toutes les lignes dans la feuille OD');
                    recL21.SETRANGE(Open, TRUE);
                    if Client <> '' then
                        recL21.SETFILTER(recL21."Customer No.", Client);
                    IF (DD <> 0D) AND (DF <> 0D) AND (DD <= DF) THEN
                        recL21.SETRANGE("Posting Date", DD, DF);
                    IF GroupC <> '' THEN
                        recL21.SETFILTER("Customer Posting Group", GroupC);

                    recL21.SETAUTOCALCFIELDS("Remaining Amt. (LCY)");
                    recL21.SETRANGE("Remaining Amt. (LCY)", mtt0, mtt1);
                    IF recL21.FINDFIRST THEN BEGIN
                        IF GenJnlBatch."No. Series" <> '' THEN
                            Doc := NoSeriesMgt.GetNextNo(
                                             GenJnlBatch."No. Series", TODAY, FALSE);
                        repeat
                            IF GenJnlLine.FINDLAST THEN;
                            GenJnlLine.INIT;
                            GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                            GenJnlLine."Journal Template Name" := feuille;
                            GenJnlLine."Journal Batch Name" := 'OD';
                            GenJnlLine.VALIDATE("Posting Date", DateC);
                            GenJnlLine.VALIDATE("Document Date", recL21."Posting Date");
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;//<<<
                            GenJnlLine.VALIDATE("Account No.", recL21."Customer No."); //<<<
                            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
                            GenJnlLine."Source Code" := journal;
                            GenJnlLine."Document No." := Doc;
                            GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
                            GenJnlLine.Description := 'APUREMENT SOLDE CLIENT';
                            recL21.CALCFIELDS("Remaining Amt. (LCY)");
                            recL21.SETAUTOCALCFIELDS("Remaining Amount");
                            GenJnlLine.VALIDATE("Amount (LCY)", -recL21."Remaining Amt. (LCY)");
                            GenJnlLine."External Document No." := FORMAT(recL21."Entry No.");
                            GenJnlLine.VALIDATE("Posting Group", recL21."Customer Posting Group");
                            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                            DocumentNo := GenJnlLine."Document No." + '/' + FORMAT(GenJnlLine."Line No.");
                            IF NOT OnlyCustNotBloqued THEN BEGIN
                                recL21."Applies-to ID" := DocumentNo;
                                recL21."Amount to Apply" := recL21."Remaining Amount";
                                recL21.MODIFY;
                                GenJnlLine."Applies-to ID" := DocumentNo;
                                GenJnlLine.INSERT;
                                mtt += recL21."Remaining Amt. (LCY)";


                            END
                            ELSE BEGIN
                                recL18.GET(recL21."Customer No.");
                                IF recL18.Blocked = recL18.Blocked::" " THEN BEGIN

                                    recL21."Applies-to ID" := DocumentNo;
                                    recL21."Amount to Apply" := recL21."Remaining Amount";
                                    recL21.MODIFY;
                                    GenJnlLine."Applies-to ID" := DocumentNo;//////
                                    GenJnlLine.INSERT;
                                    mtt += recL21."Remaining Amt. (LCY)";
                                END;
                            END;


                        UNTIL recL21.NEXT = 0;
                    end;
                    // Insertion derniŠre ligne :

                    IF mtt <> 0 THEN BEGIN
                        IF GenJnlLine.FINDLAST THEN;
                        GenJnlLine.INIT;
                        GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                        GenJnlLine."Journal Template Name" := feuille;
                        GenJnlLine."Journal Batch Name" := 'OD';
                        GenJnlLine.VALIDATE("Posting Date", DateC);
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                        IF mtt > 0 THEN
                            GenJnlLine.VALIDATE("Account No.", recGLSetup."Pertes écr. apurement")
                        ELSE
                            GenJnlLine.VALIDATE("Account No.", recGLSetup."Gains écr. apurement");

                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Source Code" := journal;
                        GenJnlLine."Document No." := Doc;
                        GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
                        GenJnlLine.Description := 'APUREMENT SOLDE CLIENT';
                        DocumentNo := GenJnlLine."Document No." + '/' + FORMAT(GenJnlLine."Line No.");//////
                        recL21.CALCFIELDS("Remaining Amt. (LCY)");
                        GenJnlLine.VALIDATE(Amount, mtt);

                        GenJnlLine."Applies-to ID" := DocumentNo;//////

                        GenJnlLine.INSERT;
                    END
                    ELSE
                        MESSAGE('La somme … apurer est nulle');


                    COMMIT;

                    /* IF CONFIRM('Voulez-vous ouvrir la feuille comptable ?''', TRUE) THEN BEGIN
                         GenJnlLine.RESET;
                         GenJnlLine.SETRANGE("Journal Template Name", 'OD');
                         GenJnlLine.SETRANGE("Journal Batch Name", GenJnlBatch.Name);
                         if GenJnlLine.IsEmpty then
                             MESSAGE('Aucune ligne … afficher')
                         ELSE
                             PAGE.RUNMODAL(0, GenJnlLine);
                     END;*/


                END
                else
                    IF apurFrns THEN BEGIN
                        IF (mtt0 > 0) OR (mtt1 < 0) OR (DateC = 0D) THEN
                            ERROR('Vérifiez les montants et/ou la date');

                        journal := 'OD';
                        feuille := 'OD';

                        recGLSetup.FIND;
                        recGLSetup.TESTFIELD("Gains écr. apurement");
                        recGLSetup.TESTFIELD("Pertes écr. apurement");

                        GenJnlTemplate.GET(feuille);
                        GenJnlBatch.SETFILTER("Journal Template Name", GenJnlTemplate.Name);
                        GenJnlBatch.FINDFIRST;

                        GenJnlLine.SETRANGE("Journal Template Name", GenJnlBatch."Journal Template Name");

                        IF (DD <> 0D) AND (DF <> 0D) AND (DD <= DF) THEN
                            recL25.SETRANGE("Posting Date", DD, DF);

                        recL25.SETRANGE(Open, TRUE);
                        IF Fournisseur <> '' THEN
                            recL25.SETFILTER(recL25."Vendor No.", Fournisseur);
                        IF GroupF <> '' THEN
                            recL25.SETFILTER("Vendor Posting Group", GroupF);

                        recL25.CALCFIELDS("Remaining Amt. (LCY)");
                        recL25.SETRANGE("Remaining Amt. (LCY)", mtt0, mtt1);
                        IF recL25.FINDFIRST THEN BEGIN
                            IF GenJnlBatch."No. Series" <> '' THEN
                                Doc := NoSeriesMgt.GetNextNo(
                                   GenJnlBatch."No. Series", TODAY, FALSE);
                            REPEAT
                                IF GenJnlLine.FINDLAST THEN;
                                GenJnlLine.INIT;
                                GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                                GenJnlLine."Journal Template Name" := feuille;
                                GenJnlLine."Journal Batch Name" := GenJnlBatch.Name;
                                GenJnlLine.VALIDATE("Posting Date", DateC);
                                GenJnlLine.VALIDATE("Document Date", recL25."Posting Date");
                                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;//<<<
                                GenJnlLine.VALIDATE("Account No.", recL25."Vendor No."); //<<<
                                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Vendor;
                                GenJnlLine."Source Code" := journal;
                                GenJnlLine."Document No." := Doc;
                                GenJnlLine."Currency Code" := recL25."Currency Code";
                                GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
                                GenJnlLine.Description := 'APUREMENT SOLDE FOURNISSEUR';
                                recL25.CALCFIELDS("Remaining Amt. (LCY)", recL25."Remaining Amount");
                                GenJnlLine.Amount := -recL25."Remaining Amount";
                                GenJnlLine.VALIDATE("Amount (LCY)", -recL25."Remaining Amt. (LCY)");
                                GenJnlLine.VALIDATE("Posting Group", recL25."Vendor Posting Group");
                                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                                GenJnlLine.INSERT;
                                mtt += recL25."Remaining Amt. (LCY)";

                            UNTIL recL25.NEXT = 0;
                        END;

                        // Insertion derniŠre ligne :


                        IF mtt <> 0 THEN BEGIN
                            IF GenJnlLine.FINDLAST THEN;
                            GenJnlLine.INIT;
                            GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                            GenJnlLine."Journal Template Name" := feuille;
                            GenJnlLine."Journal Batch Name" := GenJnlBatch.Name;
                            GenJnlLine.VALIDATE("Posting Date", DateC);
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                            IF mtt > 0 THEN
                                GenJnlLine.VALIDATE("Account No.", recGLSetup."Pertes écr. apurement")
                            ELSE
                                GenJnlLine.VALIDATE("Account No.", recGLSetup."Gains écr. apurement");

                            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                            GenJnlLine."Source Code" := journal;
                            GenJnlLine."Document No." := Doc;
                            GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
                            GenJnlLine.Description := 'APUREMENT SOLDE FOURNISSEUR';
                            recL25.CALCFIELDS("Remaining Amt. (LCY)");
                            GenJnlLine.VALIDATE(Amount, mtt);
                            GenJnlLine.INSERT;
                        END
                        ELSE
                            MESSAGE('La somme … apurer est nulle');


                        COMMIT;
                    end;
            end;





        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Paramètres)
                {
                    field(mtt0; mtt0)
                    {
                        Caption = 'Mtt. début';
                        ApplicationArea = All;
                    }
                    field(mtt1; mtt1)
                    {
                        Caption = 'Mtt. final';
                        ApplicationArea = All;
                    }
                    field(DD; DD)
                    {
                        Caption = 'Ecriture Date Début';
                        ApplicationArea = All;
                    }
                    field(DF; DF)
                    {
                        Caption = 'Ecriture Date Fin';
                        ApplicationArea = All;
                    }
                    field(DateC; DateC)
                    {
                        Caption = 'Date de validation';
                        ApplicationArea = All;
                    }


                }

                /*group("Tiers à apurer")
                {
                    field(apurClient; apurClient)
                    {
                        Caption = 'Client';
                        ApplicationArea = All;
                    }
                    field(apurFrns; apurFrns)
                    {
                        Caption = 'Fournisseur';
                        ApplicationArea = All;
                    }
                }*/
            }
        }
    }

    var
        mtt0: Decimal;
        mtt1: Decimal;
        DateC: Date;
        Client: Code[20];
        Fournisseur: Code[20];
        GroupC: Code[20];
        GroupF: Code[20];
        apurClient: Boolean;
        apurFrns: Boolean;
        OnlyCustNotBloqued: Boolean;
        DD: Date;
        DF: Date;




}
