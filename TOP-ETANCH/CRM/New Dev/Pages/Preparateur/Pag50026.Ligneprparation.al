namespace Top.Top;
using Microsoft.Inventory.Item;
using Microsoft.Purchases.Vendor;

page 50026 "Lignepréparation"
{
    ApplicationArea = All;
    Caption = 'Lignepréparation';
    APIGroup = 'TICOP';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    PageType = API;
    EntityName = 'Ligneprep';
    EntitySetName='Lignesprep';
    SourceTable = "Ligne préparation";
    ODataKeyFields = SystemId ;
    DelayedInsert = true ;

    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(Document_No; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field(Source_type; Rec."Source type.")
                {
                    ToolTip = 'Specifies the value of the Source type. field.', Comment = '%';
                }
                field(Source_No; Rec."Source No.")
                {
                    ToolTip = 'Specifies the value of the Source No. field.', Comment = '%';
                }
                field(Source_line_No; Rec."Source line No.")
                {
                    ToolTip = 'Specifies the value of the Source line No. field.', Comment = '%';
                }
                field(item_No; Rec."item No.")
                {
                    ToolTip = 'Specifies the value of the item No. field.', Comment = '%';
                }
                field(description; Rec.description)
                {
                    ToolTip = 'Specifies the value of the description field.', Comment = '%';
                }
                field(Location; Rec.Location)
                {
                    ToolTip = 'Specifies the value of the Location field.', Comment = '%';
                }
                field(Bin_Code; Rec."Bin Code")
                {
                    ToolTip = 'Specifies the value of the Bin Code field.', Comment = '%';
                }
                field(Qty; Rec.Qty)
                {
                    ToolTip = 'Specifies the value of the Qty field.', Comment = '%';
                }
                field(Statut; Rec.Statut)
                {
                    ToolTip = 'Specifies the value of the Statut field.', Comment = '%';
                }
                field(Creation_date; Rec."Creation date")
                {
                    ToolTip = 'Specifies the value of the Date de création field.', Comment = '%';
                }
                field(Date_debut_preparation; Rec."Date début préparation")
                {
                    ToolTip = 'Specifies the value of the Date début préparation field.', Comment = '%';
                }
                field(Date_fin_preparation; Rec."Date fin préparation")
                {
                    ToolTip = 'Specifies the value of the Date fin préparation field.', Comment = '%';
                }
                field(Preparateur; Rec."Préparateur")
                {
                    ToolTip = 'Specifies the value of the Préparateur field.', Comment = '%';
                }
                field(Demandeur; Rec.Demandeur)
                {
                    ToolTip = 'Specifies the value of the Demandeur field.', Comment = '%';
                }
                field(Nom_demandeur; Rec."Nom demandeur")
                {
                    ToolTip = 'Specifies the value of the Nom demandeur field.', Comment = '%';
                }
                field(Identifier_Code;Rec."Identifier Code")
                {}
                field(Fournisseur; Vendor)
                {

                }
            }
        }
        

    }
     trigger OnAfterGetRecord()
     Var  itemrec : record Item;
          Vendorrec : record Vendor;
    begin
        rec.SetAutoCalcFields("Identifier Code");
        itemrec.SetLoadFields("No.","Vendor No.");
        itemrec.get(rec."item No.");
        Vendorrec.SetLoadFields("No.",Name);
        if Vendorrec.get(itemrec."Vendor No.")then 
        Vendor:=Vendorrec.Name ;
    end;


    var 
    Vendor : Text ;
}
