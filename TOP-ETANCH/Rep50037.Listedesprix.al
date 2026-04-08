namespace Top.Top;

using Microsoft.Inventory.Item;
using Microsoft.Pricing.PriceList;

report 50037 "Liste des prix"
{
    ApplicationArea = All;
    Caption = 'Liste des prix TOP';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Liste_des_prix.RDL';
    dataset
    {
        dataitem(Itemdataitem; Item)
        {
            RequestFilterFields = "Famille Category", "Catégorie Category", "Produit Category", "Type category", "Matériau category", "Manufacturer Code", Marque, "Vendor Name";
            column(No; "No.")
            {
            }
            column(Description; Description)
            {
            }
            Column(Vendor_Name; "Vendor Name")
            {

            }
            column(UnitCost; "Unit Cost")
            {
            }
            column(UnitPrice; "Unit Price")
            {
            }
            column(FamilleCategory; "Famille Category")
            {
            }
            column(CatgorieCategory; "Catégorie Category")
            {
            }
            column(ProduitCategory; "Produit Category")
            {
            }
            column(Typecategory; "Type category")
            {
            }
            column(Marque; Marque)
            {
            }
            column(Manufacturer_Code; "Manufacturer Code")
            {

            }
            column(Matriaucategory; "Matériau category")
            {
            }
            column(Prix_standard; "Prix standard")
            {

            }
            column("Prix_marché"; "Prix marché") { }

            Column(MrgStd; MrgStd)
            { }
            Column(MargeGrosToAPPLY; MargeGrosToAPPLY)
            {

            }
            dataitem(LignePrixGros; "Price List Line")
            {
                DataItemLink = "Product No." = field("No.");
                DataItemLinkReference = Itemdataitem;
                DataItemTableView = where(/* "Price List Code" = const('GROS'), */ Status = const(active), "Price Type" = const(Sale), "Source Type" = const("Customer Price Group"));
                RequestFilterFields = "Price List Code";

                Column(Unit_Price_GROS; "Unit Price")
                {

                }
                Column(Product_No_; "Product No.") { }
                Column(Status; Status) { }
                column(Prix_standardGros; "Prix standard") { }
                column("Prix_marché_Gros"; "Prix marché") { }

                Column("MrgMarchéGROS"; "MrgMarché") { }
                Column(MrgStdGROS; MrgStd) { }
            }
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
}
