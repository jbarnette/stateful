module Fixtures
  class Campaign
    statefully do
      start :incomplete

      on :draft do
        move [:incomplete, :draft, :rejected] => :draft
      end

      on :start do
        move [:incomplete, :pending_authorization, :draft, :rejected] => :pending_authorization
      end

      on :authorize do
        move :pending_authorization => :pending_approval
        move :pending_reauthorization => :approved
      end

      on :approve do
        move :pending_approval => :approved
      end

      on :accept do
        move :rejected => :pending_authorization
      end

      on :traffic do
        move :approved => :trafficked
      end

      on :finish do
        move :trafficked => :finished
      end

      on :restart do
        move :finished => :approved
      end

      on :change_spend do
        move :pending_approval => :pending_authorization
        move [:approved, :trafficked] => :pending_reauthorization

        stay :draft, :incomplete, :rejected
      end

      on :update_theme do
        stay :draft, :incomplete, :pending_approval, 
          :approved, :trafficked, :rejected      
      end

      on :delete_theme do
        move :trafficked => :approved
        stay :draft, :incomplete, :pending_approval, :approved, :rejected
      end

      on :approve_themes do 
        move :trafficked => :approved
        stay :pending_approval, :approved
      end

      on :change_trafficking do
        move :trafficked => :approved
        stay :incomplete, :draft, :approved, :pending_approval, :rejected
      end

      on :hide do
        move [:draft, :rejected, :approved, :pending_approval, :trafficked] => :hidden
        stay :hidden
      end

      on :reject do
        move [:pending_approval, :trafficked, :approved] => :rejected
      end
    end
  end
end
