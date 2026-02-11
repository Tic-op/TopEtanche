namespace Top.Top;

using Microsoft.Inventory.Ledger;
using Microsoft.Purchases.History;
using Microsoft.Inventory.Journal;

report 50036 "Mise à jours qté restante"
{
    Caption = 'Mise à jours qté restante';
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
                ItemJnlLine: record "Item Journal Line";
            begin

                /*    if ItemLedgEntry."Remaining Quantity" = 0 then
                       CurrReport.Skip(); */

                //Filters
                ItemJnlLine.setrange("Journal Template Name", JournalTemplateName);
                ItemJnlLine.setrange("Journal Batch Name", JournalBatchName);
                ItemJnlLine.setrange("Document No.", ItemLedgEntry."Document No.");

                ItemJnlLine.setrange("Entry Type", ItemJnlLine."Entry Type"::Transfer);
                ItemJnlLine.setrange("Item No.", ItemLedgEntry."Item No.");

                ItemJnlLine.setrange("Location Code", ItemLedgEntry."Location Code");
                ItemJnlLine.setrange("Applies-to Entry", ItemLedgEntry."Entry No.");

                //Updates 
                if ItemJnlLine.findset(true) then
                    repeat
                        ItemJnlLine.Validate("Quantity", ItemLedgEntry."Remaining Quantity");
                        ItemJnlLine.validate("Quantity (Base)", ItemLedgEntry."Remaining Quantity");//new line
                                                                                                    // ItemJnlLine.validate("Invoiced Qty. (Base)", ItemLedgEntry."Remaining Quantity");//new line
                                                                                                    //    ItemJnlLine.validate("Posting Date", Today);

                        ItemJnlLine.Modify(true);

                    until
ItemJnlLine.next = 0;
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
                group(GroupName)
                {
                    group(Options)
                    {

                        field(Document; Document)
                        {
                            Caption = 'Document réception';
                            ApplicationArea = All;
                            TableRelation = "Purch. Rcpt. Header";

                        }
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
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
        Message('%1 lignes de reclassement modifiées.', Counter);
    end;

    var
        JournalTemplateName, JournalBatchName, Document : Code[20];
        NewLocationCode: Code[10];
        LineNo: Integer;
        Counter: Integer;
}
