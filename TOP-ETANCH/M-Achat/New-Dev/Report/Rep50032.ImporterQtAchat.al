namespace Top.Top;
using Microsoft.Inventory.Ledger;
using Microsoft.Purchases.History;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Journal;

report 50032 "Importer Qté Achat"
{
    Caption = 'Importer Qté Achat';

    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(ItemLedgEntry; "Item Ledger Entry")
        {
            DataItemTableView =
                where("Entry Type" = const(Purchase), Open = const(true));


            trigger OnPreDataItem()
            begin
                if Document = '' then
                    Error('Merci de préciser le document achat');
                SetRange("Document No.", Document);
            end;

            trigger OnAfterGetRecord()
            var
                ItemJnlLine: Record "Item Journal Line";
            begin
                if ItemLedgEntry."Remaining Quantity" = 0 then
                    CurrReport.Skip();

                LineNo += 10000;
                ItemJnlLine.Init();
                ItemJnlLine.Validate("Journal Template Name", JournalTemplateName);
                ItemJnlLine.Validate("Journal Batch Name", JournalBatchName);
                ItemJnlLine."Line No." := LineNo;

                ItemJnlLine."Document No." := "Document No.";

                ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::Transfer);
                ItemJnlLine.Validate("Item No.", ItemLedgEntry."Item No.");
                ItemJnlLine.Validate("Posting Date", today);

                ItemJnlLine.Validate("Location Code", ItemLedgEntry."Location Code");
                ItemJnlLine.Validate("New Location Code", NewLocationCode);

                ItemJnlLine.Validate("Quantity", ItemLedgEntry."Remaining Quantity");

                ItemJnlLine.Validate("Applies-to Entry", ItemLedgEntry."Entry No.");

                ItemJnlLine.Insert(true);
                Counter += 1;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {

                    field(Document; Document)
                    {
                        Caption = 'Document réception';
                        ApplicationArea = All;
                        TableRelation = "Purch. Rcpt. Header";

                    }

                    field(NewLocationCode; NewLocationCode)
                    {
                        Caption = 'Nouveau magasin';
                        ApplicationArea = All;
                        TableRelation = Location;

                    }
                }
            }
        }
    }
    procedure InitJournal(TemplateName: Code[10]; BatchName: Code[10])

    begin
        JournalTemplateName := TemplateName;
        JournalBatchName := BatchName;
    end;

    trigger OnPostReport()
    begin
        Message('%1 lignes de reclassement créées.', Counter);
    end;

    var
        JournalTemplateName, JournalBatchName, Document : Code[20];
        NewLocationCode: Code[10];
        LineNo: Integer;
        Counter: Integer;

}