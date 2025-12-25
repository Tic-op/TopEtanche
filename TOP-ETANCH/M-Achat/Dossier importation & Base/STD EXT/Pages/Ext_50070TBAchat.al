pageextension 50070 TBAchatExt extends 9006// order processor role center

{
    layout
    {


    }

    actions
    {
        addafter("Purchase Orders")
        {
            action(ImportFolder)

            {
                caption = 'Dossier import';
                RunObject = page 50058;
                Image = Purchase;
                ApplicationArea = all;


            }
        }
    }

    var
        myInt: Integer;
}