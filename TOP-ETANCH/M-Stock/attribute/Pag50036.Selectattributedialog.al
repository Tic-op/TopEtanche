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

                  trigger OnLookup(var Text: Text): Boolean
    var
        Itematt: Record "Item Attribute";
        PageLookup: Page "Item Attributes";
    begin
      
        PageLookup.SetTableView(itematt);
        PageLookup.LookupMode:=true;
        PageLookup.Editable:= false ; 
        if PageLookup.RunModal() = Action::LookupOK then
            PageLookup.GetRecord(Itematt);
        SelectedAttribute:= itematt.id;
        Name := Itematt.Name ;
        //exit(true);
    end; 
            }
            field(Libéllé;Name)
            {
                ApplicationArea= all ;
               // Caption = 'Nom de l''attribut';
                Editable = false ;
            }
           /*  field(Libéllé;GetLabel()){
                Editable = false ;
            } */
        }
    }

    var
        SelectedAttribute: Integer ; //Text[100];
           Name : text[250];
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

