namespace Top.Top;
using Microsoft.Inventory.Item.Attribute;

page 50110 "Select Attribute Dialog"
{
    PageType = StandardDialog;
    Caption = 'Choisir un attribut de tri';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(SelectedAttribute; SelectedAttribute)
            {
                ApplicationArea = All;
                Caption = 'Attribut';
                TableRelation = "Item Attribute" ;
                
                ToolTip = 'Choisis l’attribut sur lequel tu veux trier les articles.';
            }
            field(Libéllé;GetLabel()){
                Editable = false ;
            }
        }
    }

    var
        SelectedAttribute: Integer ; //Text[100];

    procedure GetSelectedAttribute(): integer
    var IA : Record "Item Attribute";
    begin

       /*  IA.setrange(Name,SelectedAttribute);
        IA.FindFirst();
        exit(IA.ID); */
        exit(SelectedAttribute);
    end;

    local procedure GetLabel() : Text 
    var ItemAtt : Record "Item Attribute" ;
    begin
        if ItemAtt.get(SelectedAttribute) then 
        exit(ItemAtt.Name) ;
        exit('') ;


    end;
    
}

