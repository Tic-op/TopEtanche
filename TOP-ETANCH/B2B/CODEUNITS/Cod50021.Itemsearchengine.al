codeunit 50120 "Item Search Engine"
{
    procedure ExecuteSearch(RequestText: Text): Text
    var
        JsonReq: JsonObject;
        JsonFilters: JsonArray;
        FilterObj: JsonObject;
        TempSearch: Record "Temp Item Search" temporary;
        Buffer: Record "Item Search Buffer";
        Item: Record Item;
        i: Integer;
        ItemsArray: JsonArray;
        ItemJson: JsonObject;
        CategoryToken, Token : JsonToken;
        Category: Code[20];
        FiltersToken: JsonToken;
        ResultObj: JsonObject;
        Output: Text;
    begin
        // Lire le JSON POST
        JsonReq.ReadFrom(RequestText);

        // Récupérer la catégorie
        if JsonReq.Get('category', CategoryToken) then
            Category := CategoryToken.AsValue().AsText();


        // Récupérer le tableau de filtres
        if JsonReq.Get('filters', FiltersToken) then
            JsonFilters := FiltersToken.AsArray();

        TempSearch.DeleteAll();

        // Appliquer chaque filtre
        for i := 0 to JsonFilters.Count() - 1 do begin
            JsonFilters.Get(i, Token);      // récupère l’élément du tableau
            FilterObj := Token.AsObject();  // convertit le token en JsonObject
            ApplyFilter(Buffer, TempSearch, Category, FilterObj);
        end;

        // Conserver uniquement les articles satisfaisant tous les filtres
        KeepOnlyCompleteMatches(TempSearch, JsonFilters.Count());

        // Construire le tableau JSON final
        BuildJsonResponse(TempSearch, ItemsArray);

        // Créer un objet parent pour renvoyer le tableau
        Clear(ResultObj);
        ResultObj.Add('items', ItemsArray);

        // Écrire le JSON complet dans Output et renvoyer
        ResultObj.WriteTo(Output);
        exit(Output);
    end;

    procedure ApplyFilter(Buffer: Record "Item Search Buffer"; TempSearch: Record "Temp Item Search" temporary; Category: Code[20]; FilterObj: JsonObject)
    var
        AttrCode: Code[20];
        MinVal, MaxVal : Decimal;
        TextVal: Text;
        Token: JsonToken;
    begin
        // Lire l'attribut
        if FilterObj.Get('attribute', Token) then
            AttrCode := Token.AsValue().AsText();

        Buffer.SetRange("Category Code", Category);
        Buffer.SetRange("Attribute Code", AttrCode);

        // Filtre numérique
        if FilterObj.Get('min', Token) then begin
            MinVal := Token.AsValue().AsDecimal();
            if FilterObj.Get('max', Token) then
                MaxVal := Token.AsValue().AsDecimal();
            Buffer.Setrange("Value Decimal", MinVal, MaxVal);
        end;

        // Filtre texte
        if FilterObj.Get('value', Token) then begin
            TextVal := Token.AsValue().AsText();
            Buffer.SetFilter("Value Text", '@*%1*', TextVal); // recherche partielle
        end;

        // Parcourir le buffer et remplir temp table
        if Buffer.FindSet() then
            repeat
                if TempSearch.Get(Buffer."Item No.") then
                    TempSearch."Count" += 1
                else begin
                    TempSearch.Init();
                    TempSearch."Item No." := Buffer."Item No.";
                    TempSearch."Count" := 1;
                    TempSearch.Insert();
                end;
            until Buffer.Next() = 0;
    end;

    procedure KeepOnlyCompleteMatches(var TempSearch: Record "Temp Item Search" temporary; FilterCount: Integer)
    begin
        if TempSearch.FindSet() then
            repeat
                if TempSearch."Count" < FilterCount then
                    TempSearch.Delete();
            until TempSearch.Next() = 0;
    end;

    procedure BuildJsonResponse(TempSearch: Record "Temp Item Search" temporary; var ItemsArray: JsonArray)
    var
        Item: Record Item;
        ItemJson: JsonObject;
    begin
        if TempSearch.FindSet() then
            repeat
                if Item.Get(TempSearch."Item No.") then begin
                    Clear(ItemJson);
                    ItemJson.Add('no', Item."No.");
                    ItemJson.add('reference', Item."Vendor Item No.");
                    ItemJson.Add('description', Item.Description);
                    ItemJson.Add('unitPrice', Item."Unit Price");
                    ItemJson.Add('inventory', Item.Inventory);
                    ItemsArray.Add(ItemJson);
                end;
            until TempSearch.Next() = 0;
    end;

    // Remplir le buffer avec des articles de test

}
