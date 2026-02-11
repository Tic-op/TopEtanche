namespace Top.Top;

using Microsoft.Inventory.Item;

pageextension 50042 "item list extension trie" extends "Item List"
{

    actions
    {
        addafter(ClearAttributes)
        {
            Action(Trier)
            {
                PromotedCategory = Category10;
                ApplicationArea = all;
                Promoted = true;
                Image = SortAscending;

                trigger OnAction()

                var
                    Cu: Codeunit "Attribut management";
                    TriePAge: page "item list attribut sort";
                    PageDialog: Page "Select Attribute Dialog";
                    SelectedAttr: integer;
                    itemtemp: Record item temporary;

                begin
                    if Pagedialog.runmodal = Action::OK then begin
                        SelectedAttr := PageDialog.GetSelectedAttribute();

                        if SelectedAttr > 0 then begin
                            Message('Tri des articles selon : %1', SelectedAttr);


                            cu.TrierParattribut(rec, SelectedAttr);
                            /*   TriePAge.SetRecord(itemtemp);
                              TriePAge.RunModal() ; */
                            //   Page.runmodal(PAge::"item list attribut sort", Cu.TrierParattribut(Rec,SelectedAttr))

                        end

                    end;
                end;
            }
            Action(Affectation)
            {

                Caption = 'Affectation des valeurs attributs';
                PromotedCategory = Category10;
                ApplicationArea = all;
                Promoted = true;
                Image = Allocate;
                Trigger OnAction()
                begin
                    Page.Run(50038);

                end;
            }
            Action(Categorisation)
            {

                Caption = 'Catégorisation des articles';
                PromotedCategory = Category10;
                ApplicationArea = all;
                Promoted = true;
                Image = Category;
                Trigger OnAction()
                begin
                    Page.Run(50037);

                end;
            }


        }





    }
}
