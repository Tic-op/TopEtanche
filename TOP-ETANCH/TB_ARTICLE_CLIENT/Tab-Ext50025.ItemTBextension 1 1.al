namespace BSPCloud.BSPCloud;

using Microsoft.Inventory.Item;
using Microsoft.Sales.History;
using Top.Top;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;

tableextension 50225 ItemTBextension extends Item
{
    fields
    {
        field(50127; "reference origine"; Code[100])
        {
            trigger OnValidate()

            begin
                if "reference origine" <> xrec."reference origine" then
                    UpdateUsualSearch()

            end;
        }
        field(50129; "Usual search"; Code[250])
        {

            Editable = false;
        }
        field(50130; "Marge sur achat"; Decimal)
        {
            trigger OnValidate()
            begin
                "Unit Price" := round("Unit. cost simulation" * (1 + "Marge sur achat" / 100), 0.001, '=');
            end;


        }
        field(50132; "Unit. cost simulation"; Decimal)
        {
            trigger OnValidate()
            begin
                "Unit Price" := round("Unit. cost simulation" * (1 + "Marge sur achat" / 100), 0.001, '=');
            end;


        }
        field(50131; Availability; Decimal)
        {



        }
        field(50133; AvailabilityByLocation; Decimal)
        {



        }
        field(50134; AvailabilityInTampon; Decimal)
        {



        }

        modify(Description)
        {
            trigger OnAfterValidate()

            begin
                if Description <> xrec.Description then
                    UpdateUsualSearch()

            end;
        }
        modify("Vendor Item No.")
        {
            trigger OnAfterValidate()

            begin
                // if "Vendor Item No." <> xrec."Vendor Item No." then
                UpdateUsualSearch()

            end;
        }
    }
    Keys
    {
        Key(Keyorigine; "reference origine") { }
        Key(searchKey; "Usual search") { }
    }




    Procedure GetLastSales(CustNo: Code[20]; CustName: text[100]; VAT_Rate: decimal)
    var
        SalesShipLine: record "Sales Shipment Line";
        SalesLine: Record "Sales Line";
        Hist: Record HistVenteArticle temporary;
        Pagedétail: Page "Détail vente article";
        Cust: record Customer;
    begin

        Cust.get(CustNo);

        "Pagedétail".SetCustomer(Cust);
        "Pagedétail".Setitem(Rec, VAT_Rate);
        "Pagedétail".SetRecord(Rec);
        "Pagedétail".Run();
    end;

    Procedure UpdateUsualSearch()
    begin

        "Usual search" := Description + ' ' + "Vendor Item No." + ' ' + "reference Origine";
    end;
}
