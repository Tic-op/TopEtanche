namespace Top.Top;

using Microsoft.Sales.Document;

tableextension 50038 "Sales line simulator" extends "Sales Line"
{
    procedure CalculMontantTotal(): decimal
    var
        SaleL: record "Sales Line";
        Total: Decimal;
    begin
        Total := 0;
        SaleL.setrange("Document Type", "Document Type");
        SaleL.SetRange("Document No.", "Document No.");
        if SaleL.findfirst then
            repeat
                Total += SaleL.GetLineAmountExclVAT();
            until SaleL.next = 0;
        exit(Total)
    end;

    procedure CalculTauxMarge(): decimal
    var
    begin
        //if CalculMontantCoutTotal() <> 0 then
        if CalculMontantTotal() <> 0 then
            exit((CalculMontantTotal() - CalculMontantCoutTotal()) * 100 / CalculMontantTotal())       ///   CalculMontantCoutTotal()) 
        else
            exit(999999999);
        // Message('AAA');

    end;

    procedure CalculMontantCoutTotal(): decimal
    var
        SaleL: record "Sales Line";
        TotalCout: Decimal;
    begin
        TotalCout := 0;
        SaleL.setrange("Document Type", "Document Type");
        SaleL.SetRange("Document No.", "Document No.");
        if SaleL.findfirst then
            repeat
                TotalCout += SaleL."Unit Cost" * SaleL."Quantity (Base)";
            until SaleL.next = 0;
        exit(TotalCout)

    end;
}
