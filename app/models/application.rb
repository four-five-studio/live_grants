class Application < ApplicationRecord
  broadcasts_refreshes

  def elegibility
    if amount > 10000
      "We do not fund applications over £10,000"
    elsif amount < 1000
      "We do not fund applications under £1,000"
    else
      true
    end
  end

  def elegible?
    elegibility == true
  end

  def score
    score = 0
    score += 1 if per_person < 100
    score -= 1 if per_person > 1000
    score
  end

  def per_person
    amount / people_count
  end
end
