page 50070 "Sacco Transcation  List"
{
    PageType = List;
    // CardPageId = "Receipt From Bank Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sacco Transaction Management";
    SourceTableView = sorting("Receipt No") order(descending) where(Posted = const(false));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Receipt No"; Rec."Receipt No")
                {
                    ApplicationArea = All;

                }
                field("Associated Bank Account"; Rec."Associated Bank Account")
                {
                    ApplicationArea = All;
                    Caption = ' Sending Sacco';

                }
                field("Sending Sacco Name"; Rec."Sending Sacco Name")
                {
                    ApplicationArea = All;
                    Caption = 'Sacco Name';
                    Editable = false;
                }
                field("Transaction Description"; Rec."Transaction Description")
                {
                    ApplicationArea = All;

                }

                field("Received Amount"; Rec."Received Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';

                }
                field("Sacco No"; Rec."Sacco No")
                {
                    ApplicationArea = All;
                    Caption = 'Receipient Sacco';


                }
                field("Sacco Code"; Rec."Sacco Code")
                {
                    ApplicationArea = All;
                    Visible = false;

                }
                field("Sending Sacco Description"; Rec."Sending Sacco Description")
                {

                }
                field("Receiving Sacco Description"; Rec."Receiving Sacco Description")
                {

                }
                field("Sacco Name"; Rec."Sacco Name")
                {

                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;

                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;

                }
                field("Created Time"; Rec."Created Time")
                {

                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Editable = false;

                }


            }

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

                    if Vendor.Get(rec."Associated Bank Account") then
                        Vendor.CalcFields(Balance);

                    if Vendor.Balance <= 0 then
                        Error('Balance is Zero');
                    FloatManagement.PostToSaccoAccount(Rec);
                    Rec.Posted := true;
                    rec."Posted By" := UserId;
                    if Rec.Modify(true) then
                        Message('Posted Successfully');
                end;
            }
        }
    }


}