pageextension 50000 "Gl Register Ext" extends "G/L Registers"
{
    layout
    {


    }
    actions
    {
        addafter("G/L Register")
        {
            action("Ledgers Register Report")
            {
                ApplicationArea = Suite;
                Caption = 'Ledgers Register Report';
                Image = "Report";
                ToolTip = 'View posted Ledger Entries Report';
                trigger OnAction()
                var
                    LedgersReport: Report "Ledgers Registers Report";
                begin
                    LedgersReport.GetLedgerEntries(true, Rec."No.");
                    LedgersReport.Run();
                end;
            }
        }
    }
}
