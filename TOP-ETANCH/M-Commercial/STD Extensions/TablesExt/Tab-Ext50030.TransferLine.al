namespace Top.Top;

using Microsoft.Inventory.Transfer;
using Microsoft.Inventory.Item;

tableextension 50030 TransferLine extends "Transfer Line"
{
    fields
    {
        field(50008; Preparé; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Ligne préparation" where("Source type." = const("Transfert"), "Source No." = field("Document No."), "Source line No." = field("Line No.")));

        } //AM Useless
        field(50009; "statut ligne préparation"; Option) //AM Useless
        {
            Caption = 'Statut';
            OptionMembers = "Créé","En cours","Préparé","Regroupé","livré";
            FieldClass = FlowField;
            CalcFormula = lookup("Ligne préparation".Statut where("Source type." = const("Transfert"), "Source No." = field("Document No."), "Source line No." = field("Line No.")));


        }
        field(50010; "Preparation Order No."; Code[20])
        {

            //DataClassification = ToBeClassified;
            // TableRelation = "Ordre de preparation".No WHERE("Order No" = FIELD("Document No."), Magasin = FIELD("Location Code"));
            FieldClass = FlowField;
            // CalcFormula = lookup("Ordre de preparation".No WHERE("Order No" = FIELD("Document No."), Magasin = FIELD("Location Code")));
            CalcFormula = lookup("Ligne préparation"."Document No." where("Source type." = const("Transfert"), "Source No." = field("Document No."), "Source line No." = field("Line No.")));

        }
        modify("Transfer-from Bin Code")
        {
            trigger OnAfterValidate()
            begin
                If "Quantity (Base)" > GetDisponibilite(false)
        then
                    error('Quantité non disponible');
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                If "Quantity (Base)" > GetDisponibilite(false)
        then
                    error('Quantité non disponible');
            end;
        }
    }

    /*  trigger OnModify()
    var
        OrdrePrep: Record "Ordre de preparation";
    begin
      begin 
            OrdrePrep.setrange("document type",OrdrePrep."document type"::Transfert);
            OrdrePrep.SetRange("Order No", "Document No.");
            // OrdrePrep.setrange(Statut,OrdrePrep.Statut::"Créé");
            if OrdrePrep.Findset() then begin
                //if OrdrePrep.Statut = OrdrePrep.Statut::"Créé" then
                Error('Impossible de modifier cette ligne, un bon de préparation est crée'); 
            end;
        end;
    end; */  // AM 161025 Blocage lors de la validation ==> page transfer subform
    trigger OnModify()
    var
    begin
        IF (REc."Quantity (Base)" <> xRec."Quantity (Base)") Or (rec."Transfer-To Bin Code" <> xrec."Transfer-To Bin Code") Or (rec."Transfer-to Code" <> Xrec."Transfer-to Code") then begin
            CalcFields("Preparé", "statut ligne préparation");
            if "Preparé" then
                Error('Impossible de modifier cette ligne, veuillez supprimer le bon de préparation associé.');
        end;

    end;

    trigger OnDelete()
    var
        OrdrePrep: Record "Ordre de preparation";
    begin

        CalcFields("Preparé");
        if "Preparé" then
            Error('Impossible de modifier cette ligne, veuillez supprimer le bon de préparation associé.');
        /*   begin 
                OrdrePrep.setrange("document type",OrdrePrep."document type"::Transfert);
                OrdrePrep.SetRange("Order No", "Document No.");
                //OrdrePrep.setrange(Statut,OrdrePrep.Statut::"Créé");
                if OrdrePrep.Findset() then begin
                    //if OrdrePrep.Statut = OrdrePrep.Statut::"Créé" then
                    Error('Impossible de supprimer cette ligne, un bon de préparation est crée');
                end;
            end; */
    end;

    trigger oninsert()
    var
        OrdrePrep: Record "Ordre de preparation";
    begin
        begin
            OrdrePrep.setrange("document type", OrdrePrep."document type"::Transfert);
            /*  OrdrePrep.SetRange("Order No", "Document No.");
             //OrdrePrep.setrange(Statut,OrdrePrep.Statut::"Créé");
             if OrdrePrep.Findset() then begin
                 //if OrdrePrep.Statut = OrdrePrep.Statut::"Créé" then
                 Error('Impossible d''ajouter une ligne, un bon de préparation est crée');
             end; */



            ORdreprep.setrange("Order No", "Document No.");
            ORdreprep.SetRange(Statut, ORdreprep.Statut::"Créé", ORdreprep.Statut::"En cours");
            if ORdreprep.FindFirst() then
                error('veuillez préparer les préparations existantes avant d''ajouter des lignes');
        end;
    end;




    procedure GetDisponibilite(Total: boolean): Decimal
    var
        Item: Record Item;
    begin
        if Item.Get("Item No.") then begin
            if total then
                exit(Item.CalcDisponibilité('', ''))
            else
                exit(Item.CalcDisponibilité("Transfer-from Code", "Transfer-from Bin Code"))
        end
    end;

    Procedure GetLastLineNo(): integer;
    var
        TransferL: record "Transfer Line";
    begin
        TransferL.setrange("Document No.", "Document No.");
        if TransferL.findlast() then
            exit(TransferL."Line No.")
        else
            exit(0);




    end;
}
