page 50058 "Import Folder List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Import Folder";
    CardPageId = "Import folder card";
    caption = 'Liste Dossiers Importation';


    layout
    {
        area(Content)
        {
            repeater(Group1)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;

                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;

                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Closed Date"; Rec."Closed Date")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = all;
                }
                field("N° déclaration"; Rec."N° déclaration")
                {
                    ApplicationArea = all;
                }
                field("N° Titre Importation"; Rec."N° Titre Importation")
                {
                    ApplicationArea = all;
                }
                field("Nombre de colis"; Rec."Nombre de colis")
                {
                    ApplicationArea = all;
                }
                field("Order Count"; Rec."Order Count")
                {
                    ApplicationArea = all;
                    DrillDownPageId = "Purchase Order";
                }

                field("Invoice Count"; Rec."Invoice Count")
                {
                    ApplicationArea = all;
                    DrillDownPageId = "Purchase invoice";
                }
                field("Réceptions validées"; Rec."Réceptions validées")
                {
                    ApplicationArea = all;

                }
                field("FactureAchatEnregistrées"; Rec."Factures achat enregistrées")
                {
                    ApplicationArea = all;
                }
                field("Avoirs Achat Enregistrées"; Rec."Avoirs Achat Enregistrées")
                {
                    ApplicationArea = all;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("Imprimer synthèse")
            {
                ApplicationArea = All;
                Image = TestReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                PromotedOnly = true;

                trigger OnAction()
                var
                    DI: Record "Import Folder";
                begin
                    DI.SetFilter("No.", Rec."No.");
                    Report.Run(50001, true, true, DI);

                end;
            }
        }
    }

}