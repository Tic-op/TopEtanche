namespace Top.Top;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Journal;

codeunit 50018 "Init Revaluation Inventory"
{


    procedure Run(RevalDate: Date)
    var
        ILE: Record "Item Ledger Entry";
        IJL: Record "Item Journal Line";
        CoutArticle: Record "Paramêtre marge";
        LineNo: Integer;
    begin
        LineNo := 10000;

        CoutArticle.FindSet();
        repeat
            ILE.Reset();
            ILE.SetCurrentKey("Item No.", Positive, "Location Code", "Variant Code");
            ILE.SetRange("Item No.", CoutArticle."Type articles");
            ILE.SetRange(Open, true);
            ILE.SetRange("Entry Type", ILE."Entry Type"::"Positive Adjmt.");
            ILE.SetFilter("Document No.", '*INV*');
            ILE.SetFilter(Quantity, '>0');
            if ILE.FindSet() then
                repeat
                    CreateRevalLine(
                          IJL,
                          LineNo,
                          RevalDate,
                          ILE,
                          CoutArticle.Marge);

                    LineNo += 10000;

                until ILE.next = 0;
        until CoutArticle.Next() = 0;


    end;


    local procedure CreateRevalLine(
        var IJL: Record "Item Journal Line";
        LineNo: Integer;
        RevalDate: Date;
        ILE: Record "Item Ledger Entry";
        NewUnitCost: Decimal)
    begin
        IJL.Init();
        IJL.Validate("Journal Template Name", 'RÉÉVALUATI');
        IJL.Validate("Journal Batch Name", 'DEFAUT');
        IJL."Document No." := 'REEV PR';
        IJL."Line No." := LineNo;

        //   IJL.Validate("Posting Date", RevalDate);
        IJL.Validate("value Entry Type", IJL."Value Entry Type"::Revaluation);
        IJL.Validate("Item No.", ILE."Item No.");


        IJL.Validate("Applies-to Entry", ILE."Entry No.");
        IJL.Validate("Unit Cost (Revalued)", NewUnitCost);

        IF IJL.Amount <> 0 then
            IJL.Insert(true);
    end;

    // -------------------------------------------------------------

    local procedure GetLastLineNo(): Integer
    var
        IJL: Record "Item Journal Line";
    begin
        IJL.SetRange("Journal Template Name", 'RÉÉVALUATI');
        IJL.SetRange("Journal Batch Name", 'DEFAUT');
        if IJL.FindLast() then
            exit(IJL."Line No.")
        else
            exit(0);
    end;
}
