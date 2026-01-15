
namespace TopEtanch.TopEtanch;

using Microsoft.Warehouse.Structure;

page 50081 AddDelEmp
{
    APIGroup = 'apiGroup';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'addDelEmp';
    DelayedInsert = true;
    EntityName = 'AddDelEmp';
    EntitySetName = 'AddDelEmps';
    PageType = API;
    SourceTable = Bin;
    DeleteAllowed = true;
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
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }

                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(Dedicated; Rec.Dedicated)
                {

                }
                field(CodeBarre; Rec.CodeBarre) { }
            }
        }
    }

}
