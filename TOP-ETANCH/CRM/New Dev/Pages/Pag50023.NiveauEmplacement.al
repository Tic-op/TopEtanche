namespace TopEtanch.TopEtanch;

using Microsoft.Warehouse.Structure;

page 50023 NiveauEmplacement
{
    APIGroup = 'TICOP';
    APIPublisher = 'publisherName';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'niveauEmplacement';
    DelayedInsert = true;
    EntityName = 'entityName';
    EntitySetName = 'entitySetName';
    PageType = API;
    SourceTable = Bin;
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(codeBarre; Rec.CodeBarre)
                {
                    Caption = 'CodeBarre';
                }
                field(niveauEmplacement; Rec."Niveau emplacement")
                {
                    Caption = 'Niveu emplacement';
                    Editable = true;
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
            }
        }
    }
}
