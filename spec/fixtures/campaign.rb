module Fixtures
  class Campaign
    statefully do
      start :incomplete

      event :draft do
        moves [:incomplete, :draft, :rejected] => :draft
      end

      event :start do
        moves [:incomplete, :pending_authorization, :draft, :rejected] => :pending_authorization
      end

      event :authorize do
        moves :pending_authorization => :pending_approval
        moves :pending_reauthorization => :approved
      end

      event :approve do
        moves :pending_approval => :approved
      end

      event :accept do
        moves :rejected => :pending_authorization
      end

      event :traffic do
        moves :approved => :trafficked
      end

      event :finish do
        moves :trafficked => :finished
      end

      event :restart do
        moves :finished => :approved
      end

      event :change_spend do
        moves :pending_approval => :pending_authorization
        moves [:approved, :trafficked] => :pending_reauthorization

        stays :draft, :incomplete, :rejected
      end

      event :update_theme do
        stays :draft, :incomplete, :pending_approval, 
          :approved, :trafficked, :rejected      
      end

      event :delete_theme do
        moves :trafficked => :approved
        stays :draft, :incomplete, :pending_approval, :approved, :rejected
      end

      event :approve_themes do 
        moves :trafficked => :approved
        stays :pending_approval, :approved
      end

      event :change_trafficking do
        moves :trafficked => :approved
        stays :incomplete, :draft, :approved, :pending_approval, :rejected
      end

      event :hide do
        moves [:draft, :rejected, :approved, :pending_approval, :trafficked] => :hidden
        stays :hidden
      end

      event :reject do
        moves [:pending_approval, :trafficked, :approved] => :rejected
      end
    end
  end
end
