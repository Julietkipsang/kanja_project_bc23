page 50083 settlementEntries
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = SettlementTable;
    SourceTableView = sorting("Receipt No") order(descending) where(Posted = const(false));

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Receipt No"; Rec."Receipt No")
                {
                    ApplicationArea = All;

                }
                field(sourceAccountNumber; Rec.sourceAccountNumber)
                {


                }
                field("Externa Doc No"; Rec."Externa Doc No")
                {
                    Caption = 'Transaction Id';
                }
                field(toAccountNumber; Rec.toAccountNumber)
                {

                }
                field(paybillNumber; Rec.paybillNumber)
                {

                }
                field(Types; Rec.Types)
                {

                }
                field("Received Amount"; Rec."Received Amount")
                {

                }
                field("Transaction Description"; Rec."Transaction Description")
                {

                }
                field(isStagedToOwn; Rec.isStagedToOwn)
                {

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("Post Transcation")
            {
                Caption = 'Post Transcation';
                Image = ApplyEntries;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Post Transcation ';
                trigger OnAction()
                var
                    FloatManagement: Codeunit "FOSA Management";
                    Vendor: Record vendor;

                begin
                    if Rec.Posted = true then
                        Error('This Document has been Posted');
                    FloatManagement.Deletejournline();

                    if Vendor.Get(rec.sourceAccountNumber) then
                        Vendor.CalcFields(Balance);

                    if Vendor.Balance <= 0 then
                        Error('Balance is Zero');
                    FloatManagement.PostingSettlementTransaction(Rec."Receipt No");
                    Rec.Posted := true;
                    rec."Posted By" := UserId;
                    if Rec.Modify(true) then
                        Message('Posted Successfully');
                end;
            }
        }
    }

}
