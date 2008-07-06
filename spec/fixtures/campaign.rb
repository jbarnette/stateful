module Fixtures
  class Campaign
    statefully do
      start :incomplete

      on :draft do
        moves [:incomplete, :draft, :rejected] => :draft
      end

      on :start do
        moves [:incomplete, :pending_authorization, :draft, :rejected] => :pending_authorization
      end

      on :authorize do
        moves :pending_authorization => :pending_approval
        moves :pending_reauthorization => :approved
      end

      on :approve do
        moves :pending_approval => :approved
      end

      on :accept do
        moves :rejected => :pending_authorization
      end

      on :traffic do
        moves :approved => :trafficked
      end

      on :finish do
        moves :trafficked => :finished
      end

      on :restart do
        moves :finished => :approved
      end

      on :change_spend do
        moves :pending_approval => :pending_authorization
        moves [:approved, :trafficked] => :pending_reauthorization

        stays :draft, :incomplete, :rejected
      end

      on :update_theme do
        stays :draft, :incomplete, :pending_approval, 
          :approved, :trafficked, :rejected      
      end

      on :delete_theme do
        moves :trafficked => :approved
        stays :draft, :incomplete, :pending_approval, :approved, :rejected
      end

      on :approve_themes do 
        moves :trafficked => :approved
        stays :pending_approval, :approved
      end

      on :change_trafficking do
        moves :trafficked => :approved
        stays :incomplete, :draft, :approved, :pending_approval, :rejected
      end

      on :hide do
        moves [:draft, :rejected, :approved, :pending_approval, :trafficked] => :hidden
        stays :hidden
      end

      on :reject do
        moves [:pending_approval, :trafficked, :approved] => :rejected
      end
    end
  end
end
