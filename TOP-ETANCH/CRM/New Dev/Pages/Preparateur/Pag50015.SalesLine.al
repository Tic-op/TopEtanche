namespace TopEtanch.TopEtanch;

using Microsoft.Sales.Document;
using Microsoft.Warehouse.ADCS;

page 50015 "salesLine"
{
    APIGroup = 'TICOP';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'salesLine';
    DelayedInsert = true;
    EntityName = 'ligneprep';
    EntitySetName = 'lignesprep';
    PageType = API;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type" = const(Order));
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                /*   field(NumeroBP; rec."Preparation Order No.")
                  {
                      Caption = 'Numéro BP';

                  } */

                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(itemNo; Rec."No.")
                {
                    Caption = 'Item No.';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantité';
                }
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field("BinCode"; Rec."Bin Code") { }
                /* field(codebarre; codebarre)
                { } */
                field("BarreCode"; Rec."Identifier Code")
                { }


            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        rec.SetAutoCalcFields("Identifier Code");
    end;

    var
        codebarre: code[25];

}