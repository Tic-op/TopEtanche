namespace Top.Top;

report 50016 "BonPréparation"
{
    ;
    ApplicationArea = All;
    Caption = 'Tickets Préparation';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'TicketsPréparation.rdl';
    dataset
    {
        dataitem(Ordredepreparation; "Ordre de preparation")
        {
            column(No; No)
            {
            }
            column(Statut; Statut)
            {
            }
            column(OrderNo; "Order No")
            {
            }
            column(Magasin; Magasin)
            {
            }
            column(Creationdate; "Creation date")
            {
            }
            column(Datedbutprparation; "Date début préparation")
            {
            }
            column(Datefinprparation; "Date fin préparation")
            {
            }
            column(Prparateur; "Préparateur")
            {
            }
            column(documenttype; "document type")
            {
            }
            dataitem("Ligne préparation"; "Ligne préparation")
            {
                DataItemLink = "Document No." = FIELD(No);
                DataItemLinkReference = Ordredepreparation;
                column(Document_No_; "Document No.")
                {

                }
                column(Source_type_; "Source type.") { }
                column(Source_No_; "Source No.") { }
                column(Source_line_No_; "Source line No.") { }
                column(Location; Location) { }
                column(Bin_Code; "Bin Code") { }
                column(item_No_; "item No.") { }
                column(description; description) { }
                column(Qty; Qty) { }



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
