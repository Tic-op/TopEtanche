namespace Top.Top;

using Microsoft.Purchases.Document;
using Microsoft.Inventory.Item;

reportextension 50002 "Purch.QuoteReportEXT" extends "Purchase - Quote"
{
    dataset
    {
        add(RoundLoop)
        {
            column("Vendor_item_No"; "Vendor item No.")
            {

            }
            Column("référence_origine"; "réference Origine")
            {

            }

        }
        Modify(Roundloop)
        {
            trigger OnAfterAfterGetRecord()
            var
                Itemrec: record Item;
                df: report 410;
            begin
                If Itemrec.get("Purchase Line"."No.") then begin
                    "Vendor item No." := Itemrec."Vendor Item No.";
                    "réference Origine" := Itemrec."reference origine";
                end

                else begin
                    "Vendor item No." := '';
                    "réference Origine" := '';

                end;



            end;
        }
    }
    var
        "Vendor item No.": Text[50];
        "réference Origine": Code[100];
}
