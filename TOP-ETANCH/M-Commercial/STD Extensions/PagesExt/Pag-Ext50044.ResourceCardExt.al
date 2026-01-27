
namespace TopEtanch.TopEtanch;

using Microsoft.Projects.Resources.Resource;

pageextension 50044 ResourceCardExt extends "Resource Card"
{
    layout
    {
        addafter("Employment Date")
        {
            field(Login; Rec.Login)
            {
                ApplicationArea = all;
            }
            field("Mot de passe "; Rec.PWD)
            {
                ApplicationArea = all;
                ExtendedDatatype = Masked;
            }
        }

    }
    actions
    {
        addafter("Online Map")
        {
            action("ISSSRAA")
            {

                Caption = 'ISSSRAA';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Visible = false;
                /* trigger OnAction()
                var
                    test: Codeunit "TEST-ISRA";
                begin
                    test.Run();
                end; */
            }

        }

    }
}
