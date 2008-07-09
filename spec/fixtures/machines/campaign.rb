module Fixtures
  class Campaign
    statefully do
      start :incomplete

      on :draft do
        move [:incomplete, :rejected] => :draft
        stay :draft
      end

      on :start do
        move [:incomplete, :draft, :rejected] => :authorizing
        stay :authorizing
      end

      on :authorize do
        move :authorizing => :approving
        move :reauthorizing => :approved
      end

      on :approve do
        move :approving => :approved
      end

      on :accept do
        move :rejected => :authorizing
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
        move :approving => :authorizing
        move [:approved, :trafficked] => :reauthorizing

        stay :draft, :incomplete, :rejected
      end

      on :update_widget do
        stay :draft, :incomplete, :approving, 
          :approved, :trafficked, :rejected      
      end

      on :delete_widget do
        move :trafficked => :approved
        stay :draft, :incomplete, :approving, :approved, :rejected
      end

      on :approve_widgets do 
        move :trafficked => :approved
        stay :approving, :approved
      end

      on :change_trafficking do
        move :trafficked => :approved
        stay :incomplete, :draft, :approved, :approving, :rejected
      end

      on :hide do
        move [:draft, :rejected, :approved, :approving, :trafficked] => :hidden
        stay :hidden
      end

      on :reject do
        move [:approving, :trafficked, :approved] => :rejected
      end
    end
  end
end
