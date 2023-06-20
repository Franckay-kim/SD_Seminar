/// <summary>
/// Codeunit  CSD SeminarRegPrinted (ID 50102).
/// </summary>
codeunit 50102 " CSD SeminarRegPrinted"
// Chapter 9 - Lab 1-2
// - Added Codeunit

{

    TableNo = "Seminar Registration Header";

    trigger OnRun();
    begin
        rec.Find;
        rec."No. Printed" += 1;
        rec.Modify;
        Commit;
    end;


}