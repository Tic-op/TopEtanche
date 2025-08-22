namespace BSPCloud.BSPCloud;

page 50040 "Importation offre de prix"
{
    ApplicationArea = All;
    Caption = 'Importation offre de prix';
    PageType = Worksheet;
    SourceTable = "Importation offre prix";
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            grid("Date")
            {
                field("Date Offre"; "Date")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        if "Date" = 0D then
                            Error('le champ date ne doit pas être vide');
                    end;
                }
            }
            repeater(General)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                }
                field("item No."; Rec."item No.")
                {
                    StyleExpr = color;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the item No. field.', Comment = '%';
                }
                field("Désignation"; Rec."Désignation")
                {
                    ApplicationArea = all;
                }

                field(Price; Rec.Price)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Price field.', Comment = '%';
                }
                field(IsItem; Rec.IsItem)
                {

                    ApplicationArea = all;
                }
            }
        }
    }

    Actions
    {
        area(Processing)
        {
            action(Valider)
            {
                Image = PostDocument;
                trigger OnAction()
                var
                    offrePrix: record "Offre de prix ";
                    IOP: Record "Importation offre prix";
                begin
                    if rec.findfirst then
                        repeat
                            offrePrix.init();
                            offrePrix.validate("Vendor No.", rec."Vendor No.");
                            offrePrix.validate("Item No.", rec."item No.");
                           //offrePrix."Item No." := rec."item No." ;
                           Message('%1',rec."item No.");
                            offrePrix.Price := rec.price;
                            offrePrix.Date := Date;
                            offrePrix.insert();

                        until rec.next = 0;

                    IOP.DeleteAll();



                    // CurrPage.update();

                end;


            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec.IsItem then
            color := 'Favorable'
        else
            color := 'Unfavorable';
    end;


    trigger OnOpenPage()
    begin

        "Date" := today;
    end;

    var
        "Date": Date;
        color: text;


}
