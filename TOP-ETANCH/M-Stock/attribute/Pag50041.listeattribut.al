namespace Top.Top;

using Microsoft.Inventory.Item.Attribute;
using Microsoft.Inventory.Item;

page 50041 listeattribut
{
    ApplicationArea = All;
    Caption = 'listeattribut';
    PageType = ListPart;
    SourceTable = "Item Attributes Buffer";
    Permissions = tabledata "Item Attributes Buffer" = rimd ;
  // SourceTableTemporary = true ;
    ModifyAllowed= true ; 
    InsertAllowed= true;
    DeleteAllowed = true;
    DelayedInsert = true ;

    
    layout
    {
        area(Content)
        {
            repeater(General)
            {    field(ID;Rec.ID)
            {

            }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name of the item attribute.';
                    Enabled= false ;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the type of the item attribute.';
                    Enabled= false ;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ToolTip = 'Specifies the name of the item or resource''s unit of measure, such as piece or hour.';
                    enabled = false ;
                }
            }
        }
        
    }
    actions
    {
        area(Processing)
        {
        /*     action(ajouter)
            
        {
         
            
Caption = 'Ajouter Attribut';
            ApplicationArea =  All;

            trigger OnAction()
            var
                ItemAttr: Record "Item Attribute";
            begin
                if Page.RunModal(Page::"Item Attributes", ItemAttr) = Action::LookupOK then begin
                    Rec.Init();
                    Rec."ID" := ItemAttr.ID;
                    Rec."Name" := ItemAttr.Name;
                    Rec."Type" := ItemAttr.Type;
                    Rec.Insert();
                end;
            end;
        
        } */
        }
    }
   /*  trigger OnNewRecord(BelowxRec: Boolean)
    var begin 
        begin
    Rec."ID" := -1;
    Rec."Name" := '';
end;
    end; */
    /* trigger OnOpenPage()
      begin 
        rec.DeleteAll();

      end; */

       procedure GetTempAttributes(var AttrTemp: Record "Item Attributes Buffer")
    begin
        AttrTemp.Copy(Rec);
    end;

    Trigger OnClosePage()
    var IAB : record "Item Attributes Buffer";
    begin 
    IAB.DeleteAll();

    end;
    Trigger OnOpenPage()
    var IAB : record "Item Attributes Buffer";
    begin 
    IAB.DeleteAll();

    end;
}
