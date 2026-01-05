namespace Top.Top;
using Microsoft.Inventory.Item;

report 50015 "Feuille préparation"
{
    Caption = 'Feuille préparation';
    RDLCLayout = 'Feuille Préparation.rdl';
    dataset
    {
        dataitem(Ligneprparation; "Ligne préparation")
        {
            column(DocumentNo; "Document No.")
            {
            }
            column(Sourcetype; "Source type.")
            {
            }
            column(SourceNo; "Source No.")
            {
            }
            column(itemNo; "item No.")
            {
            }
            column(description; description)
            {
            }
            column(Location; Location)
            {
            }
            column(BinCode; "Bin Code")
            {
            }
            column(Qty; Qty)
            {
            }
            column(Prparateur; "Préparateur")
            {
            }
            column(Demandeur; Demandeur)
            {
            }
            column(Nomdemandeur; "Nom demandeur")
            {
            }
            column(vendoritemref; vendoritemref) { }
            trigger OnAfterGetRecord()
            var
                itemrec: record Item;
            begin
                itemrec.get("item No.");
                vendoritemref := itemrec."Vendor Item No.";
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
    var
        vendoritemref: text;
}
