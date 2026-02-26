namespace Top.Top;
using System.Utilities;

codeunit 50121 "Item Search API"
{


    // La méthode POST de l'API
    [ServiceEnabled]
    procedure PostItemSearch(RequestBody: Text): Text
    var
        SearchEngine: Codeunit "Item Search Engine";
        ResultJSON: Text;
    begin
        // Appelle le codeunit existant avec le JSON reçu
        ResultJSON := SearchEngine.ExecuteSearch(RequestBody);
        exit(ResultJSON);
    end;
}
