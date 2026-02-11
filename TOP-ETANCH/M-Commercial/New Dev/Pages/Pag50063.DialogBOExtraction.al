namespace Top.Top;

page 50063 "Dialog BO Extraction"




{
    PageType = Card;
    ApplicationArea = All;
    Caption = 'BO Extraction';

    layout
    {
        area(content)
        {
            group(Extraction)
            {
                Caption = 'Source  d''extraction';

                field(LinkedOrderOnly; LinkedOrderOnly)
                {
                    Caption = 'Commande cadre associée';
                    //ToolTip = 'Extract only blanket order lines linked to this sales order.';
                    trigger OnValidate()
                    begin
                        if LinkedOrderOnly then
                            AllCustomerOrders := false;
                        // Ensure at least one option is selected
                        if not LinkedOrderOnly and not AllCustomerOrders then
                            LinkedOrderOnly := true;
                    end;
                }

                field(AllCustomerOrders; AllCustomerOrders)
                {
                    Caption = 'Toutes les commandes cadres du client';
                    //ToolTip = 'Extract blanket order lines from all customer orders.';
                    trigger OnValidate()
                    begin
                        if AllCustomerOrders then
                            LinkedOrderOnly := false;
                        // Ensure at least one option is selected
                        if not LinkedOrderOnly and not AllCustomerOrders then
                            AllCustomerOrders := true;
                    end;
                }
            }

            group(Insertion)
            {
                Caption = 'Cible de l''insertion';

                field(InsertInSameOrder; InsertInSameOrder)
                {
                    Caption = 'Commande courante';
                    trigger OnValidate()
                    begin
                        if InsertInSameOrder then
                            InsertInNewOrder := false;
                        // Ensure at least one option is selected
                        if not InsertInSameOrder and not InsertInNewOrder then
                            InsertInSameOrder := true;
                    end;
                }

                field(InsertInNewOrder; InsertInNewOrder)
                {
                    Caption = 'Nouvelle commande';
                    trigger OnValidate()
                    begin
                        if InsertInNewOrder then
                            InsertInSameOrder := false;
                        // Ensure at least one option is selected
                        if not InsertInSameOrder and not InsertInNewOrder then
                            InsertInNewOrder := true;
                    end;
                }
            }
        }
    }

    var
        LinkedOrderOnly: Boolean;
        AllCustomerOrders: Boolean;
        InsertInSameOrder: Boolean;
        InsertInNewOrder: Boolean;

    trigger OnOpenPage()
    begin
        // Initialize defaults: only one option in each group is true
        LinkedOrderOnly := true;
        InsertInSameOrder := true;
    end;

    procedure GetExtractionSelection(var OnlyLinked: Boolean)
    begin
        OnlyLinked := LinkedOrderOnly;
    end;

    procedure GetInsertionSelection(var SameOrder: Boolean)
    begin
        SameOrder := InsertInSameOrder;
    end;
}
